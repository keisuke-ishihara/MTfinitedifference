function [r_critical, v_theoretical, J] = theoretical( v1,v2,fcat,fres,r )
%THEORETICAL Summary of this function goes here
%   Detailed explanation goes here

%% check bounded vs unbounded
J = (v1*fres-v2*fcat)/(fres+fcat);

%% calculations based on analytical solutions

if J < 0
    % bounded dynamics
    r_critical = (sqrt(fcat)-sqrt(v1/v2*fres))^2;
    
    if r > r_critical
        
        if r < fcat
            fp_curr = fcat; fm = fres; r_curr = r; vp = v1; vm = v2;
            k_curr = ((fp_curr+fm-r_curr)*sqrt(r_curr*fp_curr)+r_curr*(-fp_curr+fm+r_curr))/(vp+vm)/(fp_curr-r_curr);
            s_curr = (2*r_curr*fm)/(fp_curr+fm-r_curr)-k_curr*(vm*fp_curr-vp*fm-r_curr*vm)/(fp_curr+fm-r_curr);
            v_theoretical = s_curr/k_curr;
        else
            v_theoretical = v1; % when r >= fcat
        end
        
    else
        v_theoretical = 0; % when 0 < r < r_c
    end
    
else
    % unbounded dynamics
    r_critical = 0;
    v_theoretical = v1; 
end




end

