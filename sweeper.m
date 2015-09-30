clear all;
close all;
% close all; clc;

v1   = 1;  % polymerization
v2   = 2;  % depolymerization
fcat = 0.6; % catastrophe
fres = 0.06; % rescue
% rs = [1.4:-0.1:0.8];
% rs = [10.^(-2:0.2:-1)];
% rs = [10.^(-1.75:0.25:0.25)];
% rs = [0.005 0.01 0.02 0.05 0.1 0.2:0.1:0.7];
% rs = [10.^(-0.9)];
rs = [0.01 0.02 0.05 0.1 0.2:0.1:1.3]*fcat;

% v1   = 30;  % polymerization
% v2   = 20;  % depolymerization
% fcat = 2; % catastrophe
% fres = 0.3; % rescue
% % rs = [1.4:-0.1:0.8];
% rs = [1:0.2:1.6];

dim  = 1;  % dimension of system

tic
v_Fishers = []; v_Holmes = []; v_sims = []; v_KKs = [];
for i = 1:length(rs) 
    
    r = rs(i);
    
    [r_c, v_theor, J] = theoretical(v1,v2,fcat,fres,r);
    [x, tpoints, sump, v_sim] = adaptivesim_plusonly(v1,v2,fcat,fres,r,dim);
    
    v_sims = [v_sims v_sim];
    v_KKs = [v_KKs v_theor];
    
%     v_Fishers = [v_Fishers sqrt(4*(v1*v2)/(fcat+fres)*r)];
%     vH = sqrt(4*v1*v2/fcat*r)/(1+r/fcat);
%     if r > fcat
% %     vH = sqrt(4*v1*v2/(fcat+fres)*r)/(1+r/(fcat+fres));
% %     if r > fcat+fres
%         vH = v1;
%     end
%     v_Holmes  = [v_Holmes vH];
    
    figure; plot(x, sump(:,end-5:end))
%     figure; plot(x, log(sump(:,end-5:end)))
    
%     run tst
    [r/fcat tpoints(end) toc]

end

finers = linspace(0,max(rs),1000);
v_KKfine = zeros(1,length(finers));
for i = 1:length(finers)    
    [r_c, v_theor, J] = theoretical(v1,v2,fcat,fres,finers(i));
    v_KKfine(1,i) = v_theor;
end
    
[rs'/fcat v_KKs' v_sims']

FigHandle = figure('Position', [500, 100, 1000, 250]);
subplot(1,3,1); hold on;
plot(finers/fcat, v_KKfine, 'g', rs/fcat, v_sims, 'ro');
plot(r_c/fcat,0, 'b*')

subplot(1,3,2); hold on;
error = abs(v_sims-v_KKs)./v_KKs;
plot(rs(rs>r_c)/fcat, error(rs>r_c), 'o', r_c/fcat,0, 'r*'); title('error');

subplot(1,3,3); hold on;
normalized = v_sims./v_KKs;
plot(rs(rs>r_c)/fcat, normalized(rs>r_c), 'o', r_c/fcat,0, 'r*'); title('normalized');