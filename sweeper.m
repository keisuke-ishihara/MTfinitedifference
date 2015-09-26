clear all;
close all; clc;

v1   = 30;  % polymerization
v2   = 20;  % depolymerization
fcat = 2; % catastrophe
fres = 0.3; % rescue
% rs = [1.4:-0.1:0.8];
rs = [1:0.2:1.8];

% rs = 1.4;

% v1   = 20;  % polymerization
% v2   = 18;  % depolymerization
% fcat = 3; % catastrophe
% fres = 1; % rescue
% rs = [0.1:0.2:3.3];

dim  = 1;  % dimension of system

% tic
v_theors = []; v_sims = [];
for i = 1:length(rs) 
    
    r = rs(i);
    
    [r_c, v_theor, J] = theoretical(v1,v2,fcat,fres,r);
    
    [x, tpoints, sump, v_sim] = adaptivesim_plusonly(v1,v2,fcat,fres,r,dim);
 
    v_theors = [v_theors v_theor];
    v_sims = [v_sims v_sim];
    
    figure;
    plot(x, sump(:,end-5:end))
%     [v_theor, v_sim]


%     figure(1); hold on;
%     plot(r,v_theor, 'bo')
%     plot(r,v_sim, 'r*')
    
%     [r toc]
%     tic
end
 
% [rs' v_theors' v_sims']

figure; hold on;
plot(rs, v_theors, 'b', rs, v_sims, 'ro');
plot(r_c, 0, 'g*');
% legend('theory','simulation');