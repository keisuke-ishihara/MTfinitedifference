function [ F ] = fun2ndpole( x )
%FUN2NDPOLE Summary of this function goes here
%   Detailed explanation goes here

% F(1) = exp(-exp(-x(1)+x(2))) - x(2)*(1+x(1)^2);
% F(2) = x(1)*cos(x(2)) + x(2)*sin(x(1)) - 0.5;

global vg vs fcat fres r

% V = x(1); k = x(2);
% s = -k*V;

s = x(1); k = x(2);

b = vg*fres-vs*fcat+vs*r;

% D = (vg+vs)^2*s^2 + 2*(vg+vs)*(vg*fres+vs*fcat)*s+(vg*fres-vs*fcat)^2;
D = ((vg-vs)*s + vg*fres-vs*fcat)^2+4*vg*vs*(s^2+s*(fcat+fres));
q = ((vg-vs)*s + vg*fres-vs*fcat+sqrt(D))/(2*vg*vs);
dDds = 2*(vg-vs)*((vg-vs)*s+vg*fres-vs*fcat)+4*vg*vs*(2*s+fcat+fres);
dqds = ((vg-vs)+0.5/sqrt(D)*dDds)/(2*vg*vs);

% dqds = ((vg-vs)*q+2*s+fcat+fres)/(2*q*vg*vs+(vg-vs)*s+vg*fres-vs*fcat);

% F(1) = (vg-vs)*s-vg*vs*(k+q)+b;
F(2) = vs*r*dqds*s+b*k-r*vs*r*q;
F(1) = s^2+((vg-vs)*k+fcat+fres)*s-vg*vs*k^2+b*k-vs*r*q;
% F(2) = 2*s^2+(2*(vg-vs)*k+fcat+fres-vs*r*dqds)*s-2*vg*vs*k^2+b*k;

end

