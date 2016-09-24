function [x, tpoints, sumgrw, p, q] = sim_plusminus(v1,v2,fcat,fres,r,dim,nucmode)
% simulates 1D advection PDE based on the non-standard method of translation
% accounts for plus and minus ends (minus end position + length)
%

cap = 1;  % carrying capacity
vchange_tol = 0.1; % criteria for convergence of advancing front
n_store = 80; % how many time points to store per iteration
n_chomp = 5;  % n_store > 2*n_chomp recommended?

%% decide on stepsizes of time and space

[r_c, v_theor, J] = theoretical(v1,v2,fcat,fres,r);

initpoprange = 10;
r_cent = 5;

dt = 0.1/max([r fcat fres]); % discretization of time
dt = single(dt);
% making this smaller has a great effect on the accuracy of the simulation

dx = gcd(v1,v2)*dt;

xmin = 0;
% xmax = max([400/v1*v_theor, 160]);
% xmax = prefixedtime*v_theor+2*initpoprange;

prefixedtime = 16; xmax=490; % for dim = 1;
% prefixedtime = 18*3; xmax=500*3; % for dim = 2;

x_init = xmin:dx:xmax;
m = length(x_init); x = x_init;

params = [v1 v2 fcat fres r dim cap dt dx n_store n_chomp vchange_tol nucmode];

%% add centrosome radius to length space

x = x+r_cent;
initpoprange = initpoprange + r_cent;

%% initial condition

p0 = zeros(m,m, 'single'); q0 = zeros(m,m,'single');
for i = 1:m;
    if (x(i)<=initpoprange && x(i)>=-10)
        
        if dim == 1
            p0(i,i) = cap*dx;
        elseif dim == 2
            p0(i,i) = cap*2*pi*(x(i)+dx)*dx;
        elseif dim == 3
            p0(i,i) = cap*4*pi*(x(i)+dx)^2*dx;
        else
            stop
        end
    end
%         p0(i,i) = .21*cap*dx;

end

curr_time = 0;
sumgrw = sum(p0,2); tpoints = 0;

%% simulation

% simulation with pre-fixed time and length space
p = p0; q = q0;
[p, q, curr_time, sumgrw, tpoints] = solver_plusminus(x, p, q, params, curr_time, prefixedtime, sumgrw, tpoints);

end

