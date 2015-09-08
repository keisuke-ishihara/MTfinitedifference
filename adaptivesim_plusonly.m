function [x, tpoints, sump] = adaptivesim_plusonly(v1,v2,fcat,fres,r,dim,r_critical,v_theoretical)
% simulates 1D advection PDE based on the non-standard method of translation
% only accounts for plus end
%
% adaptive simulator, stops when the front reaches a constant shape
%

global v1 v2 fcat fres r dim
global cap dt dx
cap = 1;  % carrying capacity

%% decide on stepsizes of time and space

dt = 0.05/max([r fcat fres]); % discretization of time
dx = gcd(v1,v2)*dt;

xmin = 1; xmax = 400;
x = xmin:dx:xmax; m = length(x);

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
prefixedtime = 50;
[x p q curr_time sump tpoints] = solver_plusonly(x p, q, curr_time, prefixedtime, sump, tpoints);

% assess similarity of the fronts
vchange = similarity(x, sump); 
[curr_time vchange]

% continue with simulations if necessary
while vchange > 0.05

    moretime = 50;
    [p q curr_time sump tpoints] = solver_plusonly(p, q, curr_time, moretime, sump, tpoints);
    vchange = similarity(x, sump);
    [curr_time vchange]

end


end

