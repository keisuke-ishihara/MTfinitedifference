function [x, tpoints, sumgrw, p, q] = sim_plusminus(v1,v2,fcat,fres,r,dim)
% simulates 1D advection PDE based on the non-standard method of translation
% only accounts for plus end
%

cap = 1;  % carrying capacity
vchange_tol = 0.1; % criteria for convergence of advancing front
n_store = 80; % how many time points to store per iteration
n_chomp = 5;  % n_store > 2*n_chomp recommended?

%% decide on stepsizes of time and space

[r_c, v_theor, J] = theoretical(v1,v2,fcat,fres,r);

initpoprange = 10;

dt = 0.1/max([r fcat fres]); % discretization of time
% dt = 0.1/max([r fcat fres]); % discretization of time
dt = single(dt);
% making this smaller has a great effect on the accuracy of the simulation

dx = gcd(v1,v2)*dt;

xmin = 0;
% xmax = max([400/v1*v_theor, 160]);
% xmax = prefixedtime*v_theor+2*initpoprange;

% prefixedtime = 16; xmax=500; % for dim = 1;
prefixedtime = 18; xmax=500; % for dim = 2;

x_init = xmin:dx:xmax;
m = length(x_init); x = x_init;

params = [v1 v2 fcat fres r dim cap dt dx n_store n_chomp vchange_tol];

%% initial condition

p0 = zeros(m,m, 'single'); q0 = zeros(m,m,'single');
for i = 1:m;
    if (x(i)<=initpoprange && x(i)>=-10)
%         p0(i,i) = 1*cap*dx;
        p0(i,i) = .01*cap*dx;
    end
%         p0(i,i) = .21*cap*dx;

end

curr_time = 0;
sumgrw = sum(p0,2); tpoints = 0;

%% simulation

% first simulation with pre-fixed time
p = p0; q = q0;
[p, q, curr_time, sumgrw, tpoints] = solver_plusminus(x, p, q, params, curr_time, prefixedtime, sumgrw, tpoints);

end

