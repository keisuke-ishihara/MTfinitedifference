function [x, tpoints, sumgrw, p, q] = sim_plusminus_batch(v1,v2,fcat,fres,r,tmax,xmax,dtfactor,dim,nucmode)
% simulates 1D advection PDE based on the non-standard method of translation
% only accounts for plus end
%
% adaptive simulator, stops when the front reaches a constant shape
%

cap = 1;  % carrying capacity
vchange_tol = 0.03; % criteria for convergence of advancing front
n_store = 100; % how many time points to store per iteration
n_chomp = 5;  % n_store > 2*n_chomp recommended?

%% decide on stepsizes of time and space

[r_c, v_theor, J, v_gap] = theoreticalnewpole(v1,v2,fcat,fres,r);

initpoprange = 10;
hardcoderate = 3;
max([r fcat fres hardcoderate])
dt = dtfactor/max([r fcat fres hardcoderate]); % discretization of time
dt = single(dt)
% making this smaller has a great effect on the accuracy of the simulation

dx = gcd(v1,v2)*dt;

xmin = 0;

% prefixedtime = tmax;

x_init = xmin:dx:xmax;
m = length(x_init); x = x_init;

params = [v1 v2 fcat fres r dim cap dt dx n_store n_chomp vchange_tol nucmode];

%% initial condition

p0 = zeros(m,m,'single'); q0 = zeros(m,m,'single');
% p0 = zeros(m,m); q0 = zeros(m,m);
for i = 1:m;
    if (x(i)<=initpoprange && x(i)>=-10)
        p0(i,i) = .2*cap*dx;
%         if i > 1
%             p0(i,i-1) = 4*cap*dx;
%         end
    end
end

curr_time = 0;
sumgrw = sum(p0,2); tpoints = 0;

%% simulation

% first simulation with pre-fixed time
p = p0; q = q0;

[p q curr_time sumgrw tpoints] = solver_plusminus(x, p, q, params, curr_time, tmax, sumgrw, tpoints);

end

