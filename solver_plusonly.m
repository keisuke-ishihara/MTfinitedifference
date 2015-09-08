function [p q curr_time sump tpoints] = solver_plusonly(x, p, q, curr_time, moretime, sump, tpoints)
%SOLVER_PLUSONLY 
%
%   solve time evolution of the system, this only accounts for plus ends
%

global v1 v2 fcat fres r dim cap dt dx

tmin = curr_time; tmax = curr_time+moretime;
t = tmin:dt:tmax;
n = length(t);
m = length(x);

p_old = p; q_old = q;

a = v1*dt/dx; 
b = v2*dt/dx; b = fix(b); 

for j = 1:n
    
    %  translation by advection     
    p = [zeros(a,1); p_old(1:(m-a))];
    q = [q_old((b+1):m); zeros(b,1)];
            
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
    
    nuc(nuc(:)<0) = 0;
    p = p + nuc;    
  
    p_old = p;
    q_old = q;
    
    % update time
    curr_time = curr_time + dt;
    
    % choose time points to add to sump
    if mod(j,floor(n/20)) == 0
        sump = [sump p];
%         sumq = [sumq q];
        tpoints = [tpoints curr_time];
    end
    
end

end

