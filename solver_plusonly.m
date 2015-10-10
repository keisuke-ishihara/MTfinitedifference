function [p q curr_time sump tpoints] = solver_plusonly(x, p, q, params, curr_time, moretime, sump, tpoints)
%SOLVER_PLUSONLY 
%
%   solve time evolution of the system, this only accounts for plus ends
%

% global v1 v2 fcat fres r dim cap dt dx n_store

% [v1 v2 fcat fres r dim cap dt dx n_store ] = params;
v1 = params(1);
v2 = params(2);
fcat= params(3);
fres= params(4);
r= params(5);
dim= params(6);
cap= params(7);
dt= params(8);
dx= params(9);
n_store= params(10);
% n_chomp = params();
% vchange_tol= params();

tmin = curr_time; tmax = curr_time+moretime;
t = tmin:dt:tmax; t = t(2:end);
n = length(t);
m = length(x);

a = v1*dt/dx; a = fix(a); 
b = v2*dt/dx; b = fix(b); 

% pflux = zeros(m,1);
% for i = 1:m;
%     if (x(i)<= 5 && x(i)>=-5)
%         pflux(i) = 0.001;
%     end
% end

for j = 2:n

    %  translation by advection     
    p = [zeros(a,1); p(1:(m-a))];
%     p = [sum(q(1:b))/a*ones(a,1); p(1:(m-a))];  % shrinking ends reflect back at origin
%     p = [cap; zeros(a-1,1); p(1:(m-a))];  % origin conc = cap
    q = [q((b+1):m); zeros(b,1)];
    
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
    nuc = r*p.*(1-p_norm/cap)*dt; 
    
%     nuc(nuc(:)<0) = 0; % no need to set this to zero, if timestep is small enough
    p = p + nuc;    
%     q = q + r*q.*(1-q/cap)*dt;
    
%     p = p+pflux;
%     q = q+pflux;
%     p(p>1) = ones(sum(p>1),1);
    
    % update time
    curr_time = curr_time + dt;
    
    % choose time points to add to sump
    if mod(j,floor(n/n_store)) == 0
        sump = [sump p];
%         sumq = [sumq q];
        tpoints = [tpoints curr_time];
    end
    
end

end

