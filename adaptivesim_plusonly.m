function [x, tpoints, sump] = adaptivesim_plusonly(v1,v2,fcat,fres,r,dim)
% simulates 1D advection PDE based on the non-standard method of translation
% only accounts for plus end
%
% adaptive simulator, stops when the front reaches a constant shape
%

global v1 v2 fcat fres r dim
global cap dt dx vchange_tol n_store n_chomp
cap = 1;  % carrying capacity
vchange_tol = 0.01; % criteria for convergence of advancing front
n_store = 10; % how many time points to store per iteration
n_chomp = 5;  % n_store > 2*n_chomp recommended?
clc;

%% decide on stepsizes of time and space

prefixedtime = 40;
moretime = 10;

dt = 0.01/max([r fcat fres]); % discretization of time
% making this smaller has a great effect on the accuracy of the simulation

dx = gcd(v1,v2)*dt;

[r_c, v_theor, J] = theoretical(v1,v2,fcat,fres,r);

xmin = 1; xmax = 400+prefixedtime*v_theor*1.2;
x_init = xmin:dx:xmax; m = length(x_init);
x = x_init;

%% initial condition

p0 = zeros(m,1); q0 = zeros(m,1);
for i = 1:m;
    if (x(i)<=50 && x(i)>=0.1)
        p0(i) = cap;
    end
end

curr_time = 0;
sump = p0; tpoints = 0;

%% simulation

% first simulation with pre-fixed time
p = p0; q = q0;
[p q curr_time sump tpoints] = solver_plusonly(x, p, q, curr_time, prefixedtime, sump, tpoints);

va = extractV(x, tpoints, sump, dim);
figure(1);
plot(curr_time, va, 'o');

% continue with simulations if necessary
top = 0.1; vchange = 0.3; vold = va;

while ( vchange > vchange_tol)||(top < 0.5)

    edgepos = whereisedge(x, p);
    if edgepos > max(x)-v_theor*1.2*moretime;
        
        % extend x space
        x = xmin:dx:(max(x)+v_theor*1.2*moretime);
        newp = zeros(length(x),1);
        
        % extend the variables p,q,sump
        newp(1:length(p)) = p;
        p = newp;
        
        newq = zeros(length(x),1);
        newq(1:length(q)) = q;
        q = newq;
        
        [h w] = size(sump);
        newsump = zeros(length(x),w);
        newsump(1:h,:) = sump;
        sump = newsump;
        
    end

    [p q curr_time sump tpoints] = solver_plusonly(x, p, q, curr_time, moretime, sump, tpoints);
   
    va = extractV(x, tpoints, sump, dim);
    vchange = abs(va-vold)/vold;

    figure(1); hold on;
    plot(curr_time, va, 'o');
    title('velocity')
    
    figure(2); hold on;
    plot(curr_time, abs(va-v_theor)/v_theor, 'o')
    title('percent error rt theory')
    
    figure(3); hold on;
    plot(curr_time, log(vchange), '*')
    title('log(vchange)')
    
    [curr_time v_theor va abs(va-v_theor)/v_theor vchange]
    
    top = max(sump(:,end));
    vold = va;
end


end

