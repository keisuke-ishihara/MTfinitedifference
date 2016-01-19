clear all;

datapath1 ='test11/';
datapath = strcat('~/Documents/simudataKorolevgroup/simudataPDE/',datapath1);


nsim = 13;

filename = strcat(datapath, 'param', num2str(nsim), '_out/PDEresult.mat');

load(filename);

hold on;
dx = x(2)-x(1);
plot(x, sumgrw(:,end)/dx)
title(strcat('nucleation=',num2str(r), ' dtfactor=',  num2str(dtfactor)));

% plot(x, sumgrw(:,10)/max(sumgrw(:,10)), x, sumgrw(:,50)/max(sumgrw(:,50)), x, sumgrw(:,70)/max(sumgrw(:,70)), x, sumgrw(:,end)/max(sumgrw(:,end)))
% hold on; plot(x, sumgrw(:,10)/max(sumgrw(:,10)), 'o', x, sumgrw(:,50)/max(sumgrw(:,50)), 'o', x, sumgrw(:,70)/max(sumgrw(:,70)), 'o', x, sumgrw(:,end)/max(sumgrw(:,end)), 'o')
% dtfactor