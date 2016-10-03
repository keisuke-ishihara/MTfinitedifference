clear all;
load('param.mat');
pwd

% scriptdir = fileparts(fileparts(fileparts(pwd)));
scriptdir = '~/MTfinitedifference/';

% old is where the parameter file exists
old = cd(scriptdir);

% call simulation
tic;
pwd
% [x, tpoints, sumgrw, p, q, v_sim] = sim_plusminus_batch(v1,v2,fcat,fres,r,tmax,xmax,dtfactor,dim);
% [x, tpoints, sumgrw, p, q] = sim_plusminus_batch(v1,v2,fcat,fres,r,tmax,xmax,dtfactor,dim);
[x, tpoints, sumgrw, p, q] = sim_plusminus_batch(v1,v2,fcat,fres,r,tmax,xmax,dtfactor,dim,nucmode);
toc

% save the results in the same directory as the param.mat file
cd(old);
filename = strcat('PDEresult.mat');
save(filename);

% % append nucleation and v_sim in txt file
% dlmwrite('PDEresultsummary.txt',[v1,v2,fcat,fres,r,tmax,xmax,dtfactor,dim,v_sim],'delimiter','\t','precision',4)


% save final plot

% toplot = sumgrw(:,10:floor(end/15):end)/(x(2)-x(1));
% [grad,im] = colorGradient([0 0.6 1],[1 0.1 0], 1+min(size(toplot)));
% 
% figure('Position', [500, 100, 350, 250]); hold on;
% plot(x, sumgrw(:,1)/(x(2)-x(1)), 'Color', grad(1,:), 'linewidth',1.2);
% for imat = 1:min(size(toplot))
%     plot(x, toplot(:,imat), 'Color', grad(imat+1,:), 'linewidth',1.2);
% end
% title(strcat(['time', num2str(tpoints(end)), 'r', num2str(r)]));
% 
% filename = strcat(['pde_r_', num2str(r)]);
% print(filename,'-dpng')

