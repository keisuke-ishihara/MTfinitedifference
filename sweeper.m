clear all; close all;

v1   = 20;  % polymerization
v2   = 18;  % depolymerization
fcat = 3; % catastrophe
fres = 1; % rescue
rs   = 0:0.2:3.2; % nucleation rate
dim  = 1;  % dimension of system


for i = 1:length(rs) 
    
    r = rs(i);
    [x, tpoints, sump, r_c, v_theor] = solve_advection(v1,v2,fcat,fres,r,dim);
    v_sim = extractV(x,tpoints,sump);

    figure(1); hold on;
    plot(r,v_theor, 'bo')
    plot(r,v_sim, 'r*')
    
end

figure(1);
legend('theory','simulation')