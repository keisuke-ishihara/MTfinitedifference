% this script interacts with simulation data for visualization/analysis

clear all; clc;

datapath1 ='test8/';
% datapath = strcat('~/Documents/github/KorolevGroup/MT1Dstochastic/experiments/',datapath1);
datapath = strcat('~/Documents/simudataKorolevgroup/simudataPDE/',datapath1);
% datapath = strcat(fileparts(pwd),'/experiments_MT1Dstoch/20150330_1/param1_out/');
addpath('~/Documents/github/KorolevGroup/MTfinitedifference/');

% xbinwidthplot = 8;
% ncond = input('enter no. of conditions');
% [grad,im] = colorGradient([0 0.6 1],[1 0.1 0], ncond);

% load list of simulation results
% olddir = cd(datapath);

% Get a list of all files and folders in this folder.
files = dir(datapath);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
subFolders(1:2) = []; 
% % Print folder names to command window.
for k = 1 : length(subFolders)
	fprintf('Sub folder #%d = %s\n', k, subFolders(k).name)
end

n = length(subFolders);

V_sims = zeros(1,n);
Js = zeros(1,n);
rs = zeros(1,n);

for k = 1:n
% for k = [2:8 10:n]

    filename = strcat(datapath, subFolders(k).name, '/PDEresultsummary.txt');
    data = dlmread(filename);
    
    v1 = data(1);
    v2 = data(2);
    fcat = data(3);
    fres = data(4);
    r = data(5);
    
    [r_critical, v_theoretical, J, v_gap] = theoreticalnewpole( v1,v2,fcat,fres,r );
    
    rs(k) = r;
    Js(k) = J;
    V_sims(k) = data(end);
    
end

rfine = linspace(0,1.1*fcat,1000);
V_theo = zeros(1,length(rfine));
for i = 1:length(rfine)
    [r_critical, v_theoretical, J, v_gap] = theoreticalnewpole( v1,v2,fcat,fres,rfine(i));
    V_theo(i) = v_theoretical;
end

figure(2); hold on
plot(rs, V_sims, 'bo')
plot(rfine,V_theo, 'b')
plot(r_critical, v_gap, 'r*')

stop








% set(0,'DefaultAxesFontSize', 16)
% set(0, 'DefaultFigurePosition', [10 10 600 450]);

% %% for each param.mat file, plot individual simulations and finally the average
% 
% figure(1); hold on;
% xlabel('distance [µm]'); ylabel('plus ends per micron'); title(datapath1)
% figure(2); hold on;
% xlabel('distance [µm]'); ylabel('MT polymer no. per micron'); title(datapath1)
% load(matfiles(1).name);
% midpts4plot = min(midpts):xbinwidthplot:max(midpts);
% 
% % for imat = 1:length(imat)
% for imat = 1:ncond
%     
%     load(matfiles(imat).name);
%     currmat = matfiles(imat).name;
%     cd([currmat(1:end-4), '_out']);
%     resultmats = dir('result*.mat');
%     accum = zeros(length(resultmats),length(midpts4plot));
%     accum2 = zeros(length(resultmats),length(midpts4plot));
%     
%     for j = 1:length(resultmats)
% 
%         load(resultmats(j).name);
%         MT = result(:,:,end);
%         plusends  = hist(MT(any(MT,2),3),midpts4plot)/xbinwidthplot;
% %         polymer  = calcmtNumber(MT,max(size(result)),midpts4plot)/xbinwidthplot;
%         accum(j,:) = plusends;       
% %         accum2(j,:) = polymer;       
% 
%     end
% 
%     meanplusends = sum(accum, 1)/length(resultmats);
% %     meanpolymer = sum(accum2, 1)/length(resultmats);
% 
% %     plot(midpts4plot, meanplusends, '*');
%     figure(1); hold on;
% %     errorbar(midpts4plot, meanplusends, std(accum), 'Color', grad(imat,:));
%     plot(midpts4plot, meanplusends, 'Color', grad(imat,:));
% %     figure(2); hold on;
% %     errorbar(midpts4plot, meanpolymer, std(accum), 'Color', grad(imat,:));
%     cd ..
%     
% end
% 
% cd(olddir)
% 
% stop
% 
% 
% %% for plotting individual simulations
% 
% addpath('~/Documents/github/KorolevGroup/MT1Dstochastic/');
% 
% plusends_accum = zeros(length(time),length(plusends));
% polymer_accum = zeros(length(time),length(plusends));
% [grad,im] = colorGradient([0 0.6 1],[1 0.1 0], length(time));
% for k = 1:length(time)
% 
%     if mod(k,4) == 0
%         MT = result(:,:,k);
%         plusends_accum(k,:) = hist(MT(any(MT,2),3),midpts4plot)/xbinwidthplot;
%         figure(3); hold on;        
%         plot(midpts4plot, plusends_accum(k,:)', 'Color', grad(k,:));
%         figure(4); hold on;        
%         plot(midpts4plot, plusends_accum(k,:)./midpts4plot, 'Color', grad(k,:));
%         
%         polymer_accum(k,:) = calcmtNumber(MT,max(size(MT)),midpts4plot);
%         figure(5); hold on;        
%         plot(midpts4plot, polymer_accum(k,:)', 'Color', grad(k,:));
%         figure(6); hold on;        
%         plot(midpts4plot, polymer_accum(k,:)./midpts4plot, 'Color', grad(k,:));
% 
%     end
%     
% end
% 
% rmpath('~/Documents/github/KorolevGroup/MT1Dstochastic/');
% 
% stop
