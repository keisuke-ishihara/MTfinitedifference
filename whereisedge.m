function [ edgepos ] = whereisedge(x, p, cap)
%WHEREISEDGE 
% given curve p, finds the position of the leading edge (decreasing slope with x)
%

% finds the maximum of the curve, anything left to the maximum is set to
% maximum
[M ind_max] = max(p);
p(1:ind_max) = M*ones(ind_max, 1);
% plot(x,p);

% finds the point corresponding to 10% of the carrying capacity (=1) 
dif = abs(p-cap*0.05*ones(length(p),1));
[M_dif ind_dif] = min(dif);
% plot(x(ind_dif), p(ind_dif),'r*')

edgepos = x(ind_dif);

end

