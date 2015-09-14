function [x, tpoints, sump] = adaptivesim_plusonly(v1,v2,fcat,fres,r,dim)
% simulates 1D advection PDE based on the non-standard method of translation
% only accounts for plus end
%
% adaptive simulator, stops when the front reaches a constant shape
%

global v1 v2 fcat fres r dim
global cap dt dx vchange_tol
cap = 1;  % carrying capacity
vchange_tol = 0.03; % criteria for convergence of advancing front
clc;

%% decide on stepsizes of time and space

prefixedtime = 10;
moretime = 30;

dt = 0.05/max([r fcat fres]); % discretization of time
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

% assess similarity of the fronts
% vchange = similarity(x, sump); 
va = extractV(x, tpoints, sump, dim);
vb = extractV(x, tpoints(1:end-10), sump(:,1:end-10), dim);
vchange = abs(vb-va)/va;
[curr_time vchange]

% continue with simulations if necessary
while vchange > vchange_tol

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
    vb = extractV(x, tpoints(1:end-10), sump(:,1:end-10), dim);
    vchange = abs(vb-va)/va;
    [curr_time vchange va vb]

end



end

