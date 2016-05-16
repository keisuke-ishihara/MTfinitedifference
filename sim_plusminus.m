function [x, tpoints, sumgrw, p, q] = sim_plusminus(v1,v2,fcat,fres,r,dim)
% simulates 1D advection PDE based on the non-standard method of translation
% only accounts for plus end
%
% adaptive simulator, stops when the front reaches a constant shape
%

cap = 1;  % carrying capacity
vchange_tol = 0.1; % criteria for convergence of advancing front
n_store = 80; % how many time points to store per iteration
n_chomp = 5;  % n_store > 2*n_chomp recommended?

%% decide on stepsizes of time and space

[r_c, v_theor, J] = theoretical(v1,v2,fcat,fres,r);

initpoprange = 10;
% if r>r_c
%     prefixedtime = prefixedtime + 10/(r-r_c);
% end

% moretime = 3;
% maxtime = 20;

dt = 0.1/max([r fcat fres]); % discretization of time
dt = single(dt);
% making this smaller has a great effect on the accuracy of the simulation

dx = gcd(v1,v2)*dt;

xmin = 0;
% xmax = max([400/v1*v_theor, 160]);
% xmax = prefixedtime*v_theor+2*initpoprange;

% if r > 2.1
    prefixedtime = 16; xmax=500;
%     prefixedtime = 32; xmax=1000;
% else
%     prefixedtime = 100; xmax = 500;
% end

x_init = xmin:dx:xmax;
m = length(x_init); x = x_init;

params = [v1 v2 fcat fres r dim cap dt dx n_store n_chomp vchange_tol];

%% initial condition

p0 = zeros(m,m, 'single'); q0 = zeros(m,m,'single');
for i = 1:m;
    if (x(i)<=initpoprange && x(i)>=-10)
        p0(i,i) = .21*cap*dx;
    end
end

curr_time = 0;
sumgrw = sum(p0,2); tpoints = 0;

%% simulation

% first simulation with pre-fixed time
p = p0; q = q0;
[p, q, curr_time, sumgrw, tpoints] = solver_plusminus(x, p, q, params, curr_time, prefixedtime, sumgrw, tpoints);


% while curr_time < maxtime
%     
%     edgepos = whereisedge(x, sum(p,2), cap/10);
%     if edgepos > max(x)-v_theor*1.4*moretime;
%         
%         % extend x space
%         x = xmin:dx:(max(x)+v_theor*1.4*moretime);
%         newp = zeros(length(x),length(x));
%         
%         % extend the variables p,q,sump
%         newp(1:length(p),1:1:length(p)) = p;
%         p = newp;
%         
%         newq = zeros(length(x),length(x));
%         newq(1:length(q),1:length(q)) = q;
%         q = newq;
%         
%         [h w] = size(sumgrw);
%         newsumgrw = zeros(length(x),w);
%         newsumgrw(1:h,:) = sumgrw;
%         sumgrw = newsumgrw;
%         
%     end
%     
%     [p q curr_time sumgrw tpoints] = solver_plusminus(x, p, q, params, curr_time, prefixedtime, sumgrw, tpoints);
%    
% %     va = extractV(x, tpoints, sump, dim, n_chomp);
% %     vchange = abs(va-vold)/abs(vold);
% %     vchange = abs(va-vold)/v1;
%     
% %     figure(1); hold on;
% %     plot(curr_time, va, 'o');
% %     title('velocity')
% %     
% %     figure(2); hold on;
% %     plot(curr_time, abs(va-v_theor)/v_theor, 'o')
% %     title('percent error rt theory')
% %     
% %     figure(3); hold on;
% %     plot(curr_time, log(vchange), '*')
% %     title('log(vchange)')
%     
% %     [curr_time v_theor va abs(va-v_theor)/v_theor vchange];
%     
% end

% va = extractV(x, tpoints, sumgrw, dim, n_chomp);
% v_sim = va;


end

