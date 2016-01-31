function [r_critical, v_theoretical, J, v_gap] = theoreticalnewpole( v1,v2,fcat,fres,r )
% function [r_critical, v_theoretical, J, fcatc, Jc] = theoretical( v1,v2,fcat,fres,r )

%THEORETICAL Summary of 11this function goes here
%   Detailed explanation goes here

%% check bounded vs unbounded
j = v1*fres-v2*fcat;
J = (v1*fres-v2*fcat)/(fres+fcat);

%% calculations based on analytical solutions

if J < 0
    % bounded dynamics
    r_critical = fcat-v1/v2*fres;
    v_gap = -v1*v2*j/(v1^2*fres+v2^2*fcat);

    if r > r_critical
        
        if r < fcat
            top = v1*j^2;
            b1 = v1*(fres+fcat)*j; 
            b2 = (v1+v2)*(v1*fres+v2*fcat)*r;
            b3 = -2*(v1+v2)*sqrt(v1*fcat*fres*r*(j+v2*r));
            v_theoretical = top/(b1+b2+b3);
        else
            v_theoretical = v1; % when r >= fcat
        end
        
    elseif r == r_critical
        v_theoretical = v_gap;
    else
        v_theoretical = 0; % when 0 < r < r_c
    end
    
elseif J == 0
    % J = 0 dynamics
    r_critical = 0;
    v_gap = 0;

    if r < fcat
%     top = v1*(v1*fres+v2*fcat+2*sqrt(v1*fcat*fres*v2));
%     bottom = v1*(fres-fcat+r)+v2*r + (v1*(fres+fcat-r)+v2*r)/v2/r*sqrt(v1*fcat*fres*v2);
        top = 2*r*v1*v2*(fcat*v2+sqrt(v1*fcat*fres*v2));
        bottom = r*(sqrt(v1*fcat*fres*v2)*(-v1+v2)+r*v2*(v1+v2))+fcat*(r*v2*(-v1+v2)+sqrt(v1*fcat*fres*v2)*(v1+v2));
        v_theoretical = top/bottom;
    else
        v_theoretical = v1;
    end
else
    % unbounded dynamics
    r_critical = 0;
    v_gap = J;
    
    if r == 0
        v_theoretical = J;
    elseif r < fcat
            top = v1*j^2;
            b1 = v1*(fres+fcat)*j; 
            b2 = (v1+v2)*(v1*fres+v2*fcat)*r;
            b3 = -2*(v1+v2)*sqrt(v1*fcat*fres*r*(j+v2*r));
            v_theoretical = top/(b1+b2+b3);
    else
        v_theoretical = v1; % when r >= fcat
    end
    
end

% fcatc = (sqrt(r)+sqrt(v1*fres/v2))^2;
% Jc = (v1*fres-v2*fcatc)/(fres+fcatc);

end

