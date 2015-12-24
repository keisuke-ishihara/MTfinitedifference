clear all;

datapath1 ='test3/';
datapath = strcat('~/Documents/simudataKorolevgroup/simudataPDE/',datapath1);


nsim = 12;

filename = strcat(datapath, 'param', num2str(nsim), '_out/PDEresult.mat');

load(filename);

figure;
plot(x, sumgrw(:,10), x, sumgrw(:,50), x, sumgrw(:,70), x, sumgrw(:,end))
title(strcat(num2str(r), '-', num2str(dtfactor)))
