function [x, tpoints, sump] = solve_advection(v1,v2,fcat,fres,r,dim)
% simulates 1D advection PDE based on the non-standard method of translation

% clear all; close all;

% v1   = 20;  % polymerization
% v2   = 16;  % depolymerization
% fcat = 3; % catastrophe
% fres = 1; % rescue
% r = 100; % nucleation rate
% 
% dim = 1;  % dimension of system

cap = 1;  % carrying capacity

%% calculations based on analytical solutions

r_critical = (sqrt(fcat)-sqrt(v1/v2*fres))^2
fp_curr = fcat; fm = fres; r_curr = r; vp = v1; vm = v2;
k_curr = ((fp_curr+fm-r_curr)*sqrt(r_curr*fp_curr)+r_curr*(-fp_curr+fm+r_curr))/(vp+vm)/(fp_curr-r_curr);
s_curr = (2*r_curr*fm)/(fp_curr+fm-r_curr)-k_curr*(vm*fp_curr-vp*fm-r_curr*vm)/(fp_curr+fm-r_curr);
v_theoretical = s_curr/k_curr

%% decide on simulation time and length scales

tmin = 0; tmax = 50;
% this increases simulation time as r approaches r_c
if r < 5*r_critical
    tmax = tmax+(ceil(1/(r-r_critical)))^2;
end
xmin = 1;
xmax = tmax*min(v_theoretical, v1)+200;
% this ensures proper xmax choice for r < r_c
if v_theoretical < 0
    xmax = 200;
end

dt = 0.05/max([r fcat fres]); % discretization of time
dx = gcd(v1,v2)*dt;

t = tmin:dt:tmax; n = length(t);
x = xmin:dx:xmax; m = length(x);

%% initial condition
p0 = zeros(m,1);
q0 = zeros(m,1);
pflux = zeros(m,1);

for i = 1:m;
    if (x(i)<=100 && x(i)>=0.1)
        p0(i) = cap;
    end
end

% % a = v1*dt/dx; a = fix(a);
% a = v1*dt/dx; 
% pflux(1:a) = 50*ones(a,1);
 
% for i = 1:m;
%     if (x(i)>=40)&(x(i)<=60)
%         p0(i,1) = 5*(x(i)-40);
%     elseif (x(i)>=60)&(x(i)<=80)
%         p0(i,1) = -5*(x(i)-60)+100;
%     end
% end

% for i = 1:m;
%     if (x(i)>=40)&(x(i)<=60)
%         q0(i,1) = 2.5*(x(i)-40);
%     elseif (x(i)>=60)&(x(i)<=80)
%         q0(i,1) = -2.5*(x(i)-60)+50;
%     end
% end
% for i = 1:m;
%     if (x(i)>=640)&(x(i)<=660)
%         q0(i,1) = 2.5*(x(i)-40);
%     end
% end
 
%% solve time evolution

p_old = p0; q_old = q0;

% a = v1*dt/dx; a = fix(a);
% b = v2*dt/dx; b = fix(b); % rounds toward zero
a = v1*dt/dx; 
b = v2*dt/dx; 

sump = p0; sumq = q0; tpoints = [0];
tic;
for j = 1:n
    
    initial = sum(p_old+q_old);

%     translation by advection     
    p = [zeros(a,1); p_old(1:(m-a))];
    q = [q_old((b+1):m); zeros(b,1)];
    
%     % constant influx at boundary
%     p = p+pflux;  
      
%     % reflecting boundary condition
%     reflect = flip([zeros(m-b,1); q_old(1:b)]);
%     p = p + reflect;
        
    % growth <-> shrink interconversion
    dp = -fcat*p*dt+fres*q*dt;
    dq = +fcat*p*dt-fres*q*dt;
    p = p+dp;
    q = q+dq;
    
    % nucleation of growing plus ends, radial geometry
    if dim == 1
        p_norm = p;
    elseif dim == 2
        p_norm = p./(2*pi*x/dx)';
    else
        stop
    end 
    nuc = r*p_norm.*(1-p/cap)*dt; 
    
    nuc(nuc(:)<0) = 0;
    p = p + nuc;    
  
    p_old = p;
    q_old = q;
    
    % choose time points to display results
    if mod(j,floor(n/20)) == 0
        sump = [sump p];
        sumq = [sumq q];
        tpoints = [tpoints j*dt];
    end
    
end
% toc;

% figure; hold on;
% plot(x, sump)

end

