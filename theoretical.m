function [r_critical, v_theoretical] = theoretical( v1,v2,fcat,fres,r )
%THEORETICAL Summary of this function goes here
%   Detailed explanation goes here

%% calculations based on analytical solutions

r_critical = (sqrt(fcat)-sqrt(v1/v2*fres))^2;
fp_curr = fcat; fm = fres; r_curr = r; vp = v1; vm = v2;
k_curr = ((fp_curr+fm-r_curr)*sqrt(r_curr*fp_curr)+r_curr*(-fp_curr+fm+r_curr))/(vp+vm)/(fp_curr-r_curr);
s_curr = (2*r_curr*fm)/(fp_curr+fm-r_curr)-k_curr*(vm*fp_curr-vp*fm-r_curr*vm)/(fp_curr+fm-r_curr);
v_theoretical = s_curr/k_curr;

end

