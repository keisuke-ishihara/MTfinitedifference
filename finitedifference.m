clear all; close all;

v1   = 6.5; % polymerization (positive)
v2   = 9.3; % depolymerization (negative)
fcat = 0.012*60; % catastrophe
fres = 0.020*60; % rescue

% v_poly   =  8.8;    v_depoly   = 13.7; 
% f_cat = 0.05*60;    f_res = 0.006*60;

J = (v1*fres - v2*fcat)/(fcat+fres);
D = v1*v2/(fcat+fres);
tau =4*D/J^2;
L = D/abs(J);

tmin = 0; tmax = 10;
xmin = 0; xmax = 160;

n = 8001;  % discretization of time
m = 641;  % discretization of space

t = linspace(tmin,tmax,n);
% a = linspace(xmin,xmax,m);  l = linspace(xmin,xmax,m);
x = linspace(xmin,xmax,m);

dt = (tmax-tmin)/(n-1);
dx = (xmax-xmin)/(m-1);

alpha1  = v1*dt/dx; alpha2  = v2*dt/dx;
beta1   = fcat*dt;  beta2   = fres*dt;
% lambda = dt/dx;

%% initial condition
p0 = zeros(m,m);
q0 = zeros(m,m);
for i = 1:m;
%     if abs(x(i)) <= 1
%         p0(i,1) = (1-abs(x(i)))*dx;
%     end
    if (x(i)>=40)&(x(i)<=60)
        p0(i,1) = 5*(x(i)-40);
    elseif (x(i)>=60)&(x(i)<=80)
        p0(i,1) = -5*(x(i)-60)+100;
    end
end

%% FTFS-FTBS scheme

% prepare sparse diagonal and band matrices
pp    = sparse(1:m  ,1:m  ,ones(m  ,1),2*m,2*m);
pp_up = sparse(1:m-1,2:m  ,ones(m-1,1),2*m,2*m);
pp_lo = sparse(2:m  ,1:m-1,ones(m-1,1),2*m,2*m);

pq    = sparse(1:m  ,(1:m)+m  ,ones(m  ,1),2*m,2*m);
pq_up = sparse(1:m-1,(2:m)+m  ,ones(m-1,1),2*m,2*m);
pq_lo = sparse(2:m  ,(1:m-1)+m,ones(m-1,1),2*m,2*m);

qp    = sparse((1:m)+m  ,1:m  ,ones(m  ,1),2*m,2*m);
qp_up = sparse((1:m-1)+m,2:m  ,ones(m-1,1),2*m,2*m);
qp_lo = sparse((2:m)+m  ,1:m-1,ones(m-1,1),2*m,2*m);

qq    = sparse((1:m)+m  ,(1:m)+m  ,ones(m  ,1),2*m,2*m);
qq_up = sparse((1:m-1)+m,(2:m)+m  ,ones(m-1,1),2*m,2*m);
qq_lo = sparse((2:m)+m  ,(1:m-1)+m,ones(m-1,1),2*m,2*m);

% specify matrices

A = sparse(2*m,2*m);
A = A + (1+alpha1-beta1)*pp - alpha1*pp_up;
A = A + beta2*pq + beta1*qp;
A = A + (1+alpha2-beta2)*qq - alpha2*qq_lo;

M_switch = sparse(2*m,2*m);
M_switch = M_switch + (1-beta1)*pp + beta2*pq + (1-beta2)*qq + beta1*qp;

M_advect = sparse(2*m,2*m);
M_advect = M_advect + (1+alpha1)*pp - alpha1*pp_up + (1+alpha2)*qq - alpha2*qq_lo;

clear pp pp_up pp_lo pq pq_up pq_lo qp qp_up qp_lo qq qq_up qq_lo;

% B*unew = A*uold
% unew = M*uold where M = B\A
% M = B\A;

%% solve the time evolution

u = zeros(2*m,m,3);
u(:,:,1) = [p0; q0];      % initialize solution 2m-by-n matrix

tic;
tot = zeros(1,n);
for j = 1:2000
    
    % step 1: switching update
    u(:,:,2) = M_switch*u(:,:,1);
    
    % step 2: 1d advection update
    u(:,:,3) = M_advect*u(:,:,2);
    
    % boundary conditions
%     u(1  ,new) = 0;     % conc = 0 at left
%     u(1+m,new) = 0;     % conc = 0 at left

    u(1,1,3) = u(1+m,1,1);  % conversion of shrinking length 0 MTs to growing length 0  
    u(1+m,1,3) = 0;           % continuity of shrinking MTs
    
%     u(m,new)   = u(m-1,new);        % right
%     u(2*m,new) = u(2*m-1,new);      % right
    
    tot(j) = sum(sum(u(:,:,3)));
    
    u(:,:,1) = u (:,:,3);
    
%     if mod(j,100) == 1
%         figure(1); hold on
%         plot(x, u(1:m,1,3))
%     end
    
end

% u = zeros(2*m,m,2);
% u(:,:,1) = [p0; q0];      % initialize solution 2m-by-n matrix
% 
% tic;
% tot = zeros(1,n);
% 
% for j = 1:n
%        
%     new = mod(j,2)+1;
%     old = mod(j+1,2)+1;
% 
%     u(:,:,new) = A*u(:,:,old);
% 
%     % boundary conditions
% %     u(1  ,new) = 0;     % conc = 0 at left
% %     u(1+m,new) = 0;     % conc = 0 at left
% 
%     u(1,1,new) = u(1+m,1,old);  % conversion of shrinking length 0 MTs to growing length 0  
%     u(1+m,1,new) = 0;           % continuity of shrinking MTs
%     
% %     u(m,new)   = u(m-1,new);        % right
% %     u(2*m,new) = u(2*m-1,new);      % right
%     
%     tot(j) = sum(sum(u(:,:,new)));
%     
% end
toc

p_final = u(1:m,1,3);
q_final = u(m+1:2*m,1,3);

figure(1)
% subplot(2,1,1)
plot(x,p_final,x,q_final)

stop

min(p_final)
min(q_final)


stop
plot(t,tot/tot(1))
title('total no. of plus ends');


stop;

figure(2)
subplot(1,2,2)
plot(x,p_final,x,q_final)

[alpha1 alpha2]
[beta1 beta2]
