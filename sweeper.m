clear all; close all; clc;

v1   = 20;  % polymerization
v2   = 30;  % depolymerization
fcat = 2; % catastrophe
fres = 1.2; % rescue
% rs   = 0:0.1:2; % nucleation rate
rs = 1;
dim  = 1;  % dimension of system

tic
for i = 1:length(rs) 
    
    r = rs(i);
    
    [r_c, v_theor, J] = theoretical(v1,v2,fcat,fres,r);
    
%     [x, tpoints, sump] = solve_advection(v1,v2,fcat,fres,r,dim,r_c,v_theor);
    [x, tpoints, sump] = adaptivesim_plusonly(v1,v2,fcat,fres,r,dim);
%     [x, tpoints, sump] = adaptivesim_plusonly(v1,v2,fcat,fres,r,dim);
    figure; plot(x,sump)

%     v_sim = extractV(x,tpoints,sump,dim);
 
%     figure(1); hold on;
%     plot(r,v_theor, 'bo')
%     plot(r,v_sim, 'r*')
    
%     [r toc]
%     tic
end

% figure(1);
% legend('theory','simulation')