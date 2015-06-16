clear all; close all;

v1   = 25;  % polymerization
v2   = 15;  % depolymerization
fcat = 0.3; % catastrophe
fres = 0.1; % rescue
% fcat = 0; % catastrophe
% fres = 0; % rescue
cap = 100;

dim = 1; % dimension of system

r = 0; % nucleation rate
% r = 0; % nucleation rate

J = (v1*fres - v2*fcat)/(fcat+fres)
D = v1*v2/(fcat+fres);
tau =4*D/J^2;
L = D/abs(J);

r_critical = (sqrt(fcat)-sqrt(v1/v2*fres))^2

fp_curr = fcat; fm = fres; r_curr = r; vp = v1; vm = v2;
k_curr = ((fp_curr+fm-r_curr)*sqrt(r_curr*fp_curr)+r_curr*(-fp_curr+fm+r_curr))/(vp+vm)/(fp_curr-r_curr);
s_curr = (2*r_curr*fm)/(fp_curr+fm-r_curr)-k_curr*(vm*fp_curr-vp*fm-r_curr*vm)/(fp_curr+fm-r_curr);
v_theoretical = s_curr/k_curr


tmin = 0; tmax = 30;
xmin = 1; xmax = 800;

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

a = v1*dt/dx; a = fix(a);
pflux(1:a) = 50*ones(a,1);
 
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

a = v1*dt/dx; a = fix(a);
b = v2*dt/dx; b = fix(b); % rounds toward zero

sump = p0;
sumq = q0;
tpoints = [0];
for j = 1:n
    
    initial = sum(p_old+q_old);

    % translation by advection     
%     p = [zeros(a,1); p_old(1:(m-a))];
%     q = [q_old((b+1):m); zeros(b,1)];


    % translation by advection with radial geometry
    p_old_r = p_old.*((x./(x+v1*dt)).^(dim-1))';
    p = [zeros(a,1); p_old_r(1:(m-a))];
    
    q_old_r = q_old.*((x./(x-v2*dt)).^(dim-1))';
    q = [q_old_r((b+1):m); zeros(b,1)];
    
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
    
%     if j == n
%         figure; plot(x,p)
%         figure; plot(x, nuc)
%     end
    
%     nuc(nuc(:)<0) = 0;
    
    p = p + nuc;    
  
    p_old = p;
    q_old = q;
        
    if mod(j,5/dt) == 1
%         sump = [sump smooth(p,100)];
%         sumq = [sumq smooth(q,100)];
        sump = [sump p];
        sumq = [sumq q];
        tpoints = [tpoints j*dt];
    end
    
end

% figure(1); hold on;
% plot(x,p,x,q)
% legend('p0', 'q0', 'p', 'q')

yaxismax = max(max(sump(fix(40/dx):end,:)));

figure; hold on;
plot(x, sump)
axis([0 xmax 0 yaxismax])
% plot(x, cap*ones(length(x),1))
% sum(sump+sumq)
 
% figure;
% plot(x,sump.*repmat(x',1,length(tpoints)))

