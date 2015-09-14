function [x, tpoints, sump] = adaptivesim_plusonly(v1,v2,fcat,fres,r,dim)
% simulates 1D advection PDE based on the non-standard method of translation
% only accounts for plus end
%
% adaptive simulator, stops when the front reaches a constant shape
%

global v1 v2 fcat fres r dim
global cap dt dx
cap = 1;  % carrying capacity
clc;

%% decide on stepsizes of time and space

prefixedtime = 10;
moretime = 30;

dt = 0.05/max([r fcat fres]); % discretization of time
dx = gcd(v1,v2)*dt;

[r_c, v_theor, J] = theoretical(v1,v2,fcat,fres,r);

xmin = 1; xmax = 100+prefixedtime*v_theor*1.2;
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
vchange = 1;
% [curr_time vchange]

% continue with simulations if necessary
while vchange > 0.05

    edgepos = whereisedge(x, p)
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
%     vchange = similarity(x, sump);
    vchange = vchange - 0.3;
%     [curr_time vchange]

end


end

