function [p q curr_time sumgrw tpoints] = solver_plusminus(x, p, q, params, curr_time, moretime, sumgrw, tpoints)
%SOLVER_PLUSMINUS 
%
%   solve time evolution of the system, this accounts for plus and minus ends
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
n_chomp = params(11);
vchange_tol= params(12);
nucmode= params(13);

tmin = curr_time; tmax = curr_time+moretime;
t = tmin:dt:tmax; t = t(2:end);
n = length(t);
m = length(x);

a1 = v1*dt/dx; a2 = fix(a1); [a1 a2]
b1 = v2*dt/dx; b2 = fix(b1); [b1 b2]
a = a2; b = b2;


% pflux = zeros(m,1);
% for i = 1:m;
%     if (x(i)<= 5 && x(i)>=-5)
%         pflux(i) = 0.001;
%     end
% end

count = [sum(sum(p))+sum(sum(q))];
for j = 2:n

    %  translation by advection     
    p = [zeros(a,a) zeros(a,m-a); zeros(m-a,a) p(1:(m-a),1:(m-a))];
    reb = trace(q(1:b,1:b)); % only MTs with minusend at origin renucleate
    for k = 1:a
        p(k,k) = reb/a;
    end
    q = [q(b+1:m,b+1:m) zeros(m-b,b); zeros(b,m-b) zeros(b,b)];
        
    % growth <-> shrink interconversion
    dp = -fcat*p*dt+fres*q*dt;
    dq = +fcat*p*dt-fres*q*dt;
    
    % nucleation of growing plus ends, radial geometry
    if nucmode == 1
        
        % plus end stimulated nucleation
        if dim == 1
            grw_norm = sum(p,2)/dx;
        elseif dim == 2
            grw_norm = sum(p,2)./(2*pi*(x+dx)*dx)';
        elseif dim == 3
            grw_norm = sum(p,2)./(4*pi*(x+dx).^2*dx)';
        else
            stop
        end
        
        nuc = r*sum(p,2).*(1-grw_norm/cap)*dt;
%     nuc(nuc(:)<0) = 0; % no need to set this to zero, if timestep is small enough

    elseif nucmode == 2
        
        % plus end stimulated nucleation
        if dim ==1 
        
            % calculate the total polymer for each spatial bin
            polymer = calcpolymer(p+q,'dp')/dx; 
            nuc = r*polymer.*(20-polymer)*dt;
            nuc(nuc(:)<0) = 0;
            
        else
            stop
        end
        
                
    end
    
    
    if j == 10
        figure; plot(sum(p+q,2));
        figure; plot(calcpolymer(p+q,'dp')); stop
    end

    dp(:,1) = dp(:,1) + nuc;
    
    p = p+dp;
    q = q+dq;
        
%     % regulation of fcat scenario
%     % nucleation of growing plus ends, radial geometry
%     if dim == 1
%         grw_norm = sum(p,2)/dx;
%     elseif dim == 2
%         grw_norm = sum(p,2)./(2*pi*(x+dx)*dx)';
%     elseif dim == 3
%         grw_norm = sum(p,2)./(4*pi*(x+dx).^2*dx)';
%     else
%         stop
%     end
%     
%     % growth <-> shrink interconversion with spatial regulation of fcat
%     fcatspatial = fcat*(1+grw_norm/cap);
%     fcatspatial = repmat(fcatspatial,1,m);
%     dp = -fcatspatial.*p*dt+fres*q*dt;
%     dq = +fcatspatial.*p*dt-fres*q*dt;
%     
%     nuc = r*sum(p,2)*dt;
% %       nuc = r*sum(p,2).*(1-grw_norm/cap)*dt;
% %     nuc(nuc(:)<0) = 0; % no need to set this to zero, if timestep is small enough    
%     dp(:,1) = dp(:,1) + nuc;
%     
%     p = p+dp;
%     q = q+dq;
    
    
    % update time
    curr_time = curr_time + dt;
    
    % choose time points to add to sump
    if n < n_store
        sumgrw = [sumgrw sum(p,2)];
        tpoints = [tpoints curr_time];
        count = [count sum(sum(p))+sum(sum(q))];    
    elseif mod(j,floor(n/n_store)) == 0
        sumgrw = [sumgrw sum(p,2)];
        tpoints = [tpoints curr_time];
        count = [count sum(sum(p))+sum(sum(q))];
    end
    
end

% figure('Position', [100, 700, 300, 250]);
% plot(tpoints, count/count(1));
% title('no. particles');
% axis([0 tpoints(end) 0 1.1*max(count)/count(1)])

end

