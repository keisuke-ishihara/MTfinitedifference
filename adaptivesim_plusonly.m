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

dt = 0.05/max([r fcat fres]); % discretization of time
dx = gcd(v1,v2)*dt;

xmin = 1; xmax = 1000;
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
prefixedtime = 20; p = p0; q = q0;
[p q curr_time sump tpoints] = solver_plusonly(x, p, q, curr_time, prefixedtime, sump, tpoints);

% assess similarity of the fronts
% vchange = similarity(x, sump); 
vchange = 1;
[curr_time vchange]

% continue with simulations if necessary
while vchange > 0.05

    moretime = 20;
%     if edgepos 
%     end
    [p q curr_time sump tpoints] = solver_plusonly(x, p, q, curr_time, moretime, sump, tpoints);
%     vchange = similarity(x, sump);
    vchange = vchange - 0.49;
    [curr_time vchange]

end


end

