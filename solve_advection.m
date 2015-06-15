clear all; close all;

v1   = 25;  % polymerization
v2   = 15;  % depolymerization
fcat = 0.3; % catastrophe
fres = 0.03; % rescue
% fcat = 0; % catastrophe
% fres = 0; % rescue
cap = 2;

r = 0; % nucleation rate
% r = 0; % nucleation rate

J = (v1*fres - v2*fcat)/(fcat+fres)
D = v1*v2/(fcat+fres);
tau =4*D/J^2;
L = D/abs(J);

r_critical = (sqrt(fcat)-sqrt(v1/v2*fres))^2

tmin = 0; tmax = 30;
xmin = 0; xmax = 1000;

dt = 0.05; % discretization of time
dx = v1*dt/100;

t = tmin:dt:tmax; n = length(t);
x = xmin:dx:xmax; m = length(x);

%% initial condition
p0 = zeros(m,1);
q0 = zeros(m,1);
pflux = zeros(m,1);

% for i = 1:m;
%     if (x(i)<=10 && x(i)>=0.1)
%         p0(i) = 1;
%     end
% end
for i = 1:m;
    if (x(i)<= 2 && x(i)>=0.1)
        pflux(i) = 2;
    end
end


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


%% solve time evolution

p_old = p0; q_old = q0;

a = v1*dt/dx; a = fix(a);
b = v2*dt/dx; b = fix(b); % rounds toward zero

sump = p0;
sumq = q0;
tpoints = [];
for j = 1:n
    
    initial = sum(p_old+q_old);

    % translation by advection     
    p = [zeros(a,1); p_old(1:(m-a))];  
    q = [q_old((b+1):m); zeros(b,1)];
    
    % constant influx at boundary
    p = p+pflux;  
    
  
%     % reflecting boundary condition
%     reflect = flip([zeros(m-b,1); q_old(1:b)]);
%     p = p + reflect;
        
    % growth <-> shrink interconversion
    dp = -fcat*p*dt+fres*q*dt;
    dq = +fcat*p*dt-fres*q*dt;
    p = p+dp;
    q = q+dq;
    
    % nucleation of growing plus ends  
    nuc = r*p.*(1-p/cap)*dt; 
    p = p + nuc;    
  
    p_old = p;
    q_old = q;
        
    if mod(j,10/dt) == 1
        sump = [sump p];
        sumq = [sumq q];
        tpoints = [tpoints j*dt];
    end
    
end

% figure(1); hold on;
% plot(x,p,x,q)
% legend('p0', 'q0', 'p', 'q')

figure;
plot(x, sump/cap)
sum(sump+sumq)

