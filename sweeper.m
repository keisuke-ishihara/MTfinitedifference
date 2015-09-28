clear all;
% close all; clc;

v1   = 1;  % polymerization
v2   = 1;  % depolymerization
fcat = 1; % catastrophe
fres = 1; % rescue
% rs = [1.4:-0.1:0.8];
% rs = [10.^(-2:0.2:-1)];
% rs = [10.^(-1.75:0.25:0.25)];
rs = [0.005 0.01 0.02 0.05 0.1 0.2:0.1:1.4];
% rs = [10.^(-0.9)];

% v1   = 30;  % polymerization
% v2   = 20;  % depolymerization
% fcat = 2; % catastrophe
% fres = 0.3; % rescue
% % rs = [1.4:-0.1:0.8];
% rs = [1:0.2:1.6];


dim  = 1;  % dimension of system

tic
v_theors = []; v_sims = []; v_theors2 = [];
for i = 1:length(rs) 
    
    r = rs(i);
    
    [r_c, v_theor, J] = theoretical(v1,v2,fcat,fres,r);
    
    [x, tpoints, sump, v_sim] = adaptivesim_plusonly(v1,v2,fcat,fres,r,dim);
 
%     v_theors = [v_theors v_theor];
    v_theors = [v_theors sqrt(4*(v1*v2)/(fcat+fres)*r)];
    v_sims = [v_sims v_sim];
%     v_theors2 = [v_theors2 sqrt(4*(v1*v2)/(fcat+fres)*r)/(1+0.5*r/fcat)];

%     vt2 = (2*(2-r/fcat)+sqrt(r/fcat))/(sqrt(r/fcat)+r/fcat);
    vt2 = v_theor;
    if r > 1
        vt2= v1;
    end
    v_theors2 = [v_theors2 vt2];
    
    
    
%     figure; plot(x, sump(:,end-5:end))
%     figure; plot(x, log(sump(:,end-5:end)))
    
    run tst

    %     figure;
%     dx = x(end)-x(end-1);
%     plot( x(2:end),1/dx*diff(log(smooth(sump(:,end)))),'.')

%     [v_theor, v_sim]

%     figure(1); hold on;
%     plot(r,v_theor, 'bo')
%     plot(r,v_sim, 'r*')
    
    [r toc]

end

    
[rs' v_theors' v_theors2' v_sims']

figure; hold on;
% plot(rs, v_theors, 'b', rs, v_theors2, 'g', rs, v_sims, 'ro');
plot(rs, v_theors2, 'g', rs, v_sims, 'ro');
figure; hold on;
plot(rs, abs(v_sims-v_theors2)./v_theors2, 'o'); title('percent error');
figure;
plot(rs, v_sims./v_theors2, 'o'); title('normalized');
% figure; hold on;
% plot(rs, v_sims, 'o');
% plot(r_c, 0, 'g*');
% legend('theory','simulation');