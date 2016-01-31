clear all;

datapath1 ='test8/';
datapath = strcat('~/Documents/simudataKorolevgroup/simudataPDE/',datapath1);


nsim = 6;

filename = strcat(datapath, 'param', num2str(nsim), '_out/PDEresult.mat');

load(filename);

% figure; hold on;
% dx = x(2)-x(1);
% plot(x, sumgrw(:,end)/dx)
% % plot(x, sumgrw(:,end-20)/dx)
% % plot(x, sumgrw(:,end-20)/dx)
% % plot(x, sumgrw(:,end-20-20)/dx)
% % tpoints(end)
% % tpoints(end-20)
% % tpoints(end)-tpoints(end-20)
% % tpoints(end-20)
% % tpoints(end-20-20)
% % tpoints(end-20)-tpoints(end-20-20)
% 
% title(strcat('nucleation=',num2str(r), ' dtfactor=',  num2str(dtfactor)));

[a1, a2, a3, a4] = theoreticalnewpole(v1,v2,fcat,fres,r);

[velocity] = extractV(x, tpoints, sumgrw, dim, n, 1-a1/r)



% plot(x, sumgrw(:,10)/max(sumgrw(:,10)), x, sumgrw(:,50)/max(sumgrw(:,50)), x, sumgrw(:,70)/max(sumgrw(:,70)), x, sumgrw(:,end)/max(sumgrw(:,end)))
% hold on; plot(x, sumgrw(:,10)/max(sumgrw(:,10)), 'o', x, sumgrw(:,50)/max(sumgrw(:,50)), 'o', x, sumgrw(:,70)/max(sumgrw(:,70)), 'o', x, sumgrw(:,end)/max(sumgrw(:,end)), 'o')
% dtfactor