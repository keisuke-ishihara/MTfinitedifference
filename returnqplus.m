function [ q dqds ] = returnqplus( s )
%RETURNQPLUS Summary of this function goes here
%   Detailed explanation goes here

global vg vs fcat fres r

D = ((vg-vs)*s + vg*fres-vs*fcat)^2+4*vg*vs*(s^2+s*(fcat+fres));
dDds = 2*(vg-vs)*((vg-vs)*s+vg*fres-vs*fcat)+4*vg*vs*(2*s+fcat+fres);
dqds = ((vg-vs)+0.5/sqrt(D)*dDds)/(2*vg*vs);

q1 = ((vg-vs)*s + vg*fres-vs*fcat+sqrt(D))/(2*vg*vs);
q2 = ((vg-vs)*s - vg*fres-vs*fcat+sqrt(D))/(2*vg*vs);


q = q1;

end

