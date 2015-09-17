clear all;
% close all; clc;

v1   = 20;  % polymerization
v2   = 30;  % depolymerization
fcat = 2; % catastrophe
fres = 0.3; % rescue
% rs   = 0:0.1:2; % nucleation rate
rs = [0.6:0.05:2.4];
dim  = 1;  % dimension of system

tic
v_theors = []; v_sims = [];
for i = 1:length(rs) 
    
    r = rs(i);
    
    [r_c, v_theor, J] = theoretical(v1,v2,fcat,fres,r);
    
    [x, tpoints, sump, v_sim] = adaptivesim_plusonly(v1,v2,fcat,fres,r,dim);
 
    v_theors = [v_theors v_theor];
    v_sims = [v_sims v_sim];
%     [v_theor, v_sim]


%     figure(1); hold on;
%     plot(r,v_theor, 'bo')
%     plot(r,v_sim, 'r*')
    
%     [r toc]
%     tic
end
 
% [rs' v_theors' v_sims']

figure;
plot(rs, v_theors, 'b', rs, v_sims, 'r*');
legend('theory','simulation')