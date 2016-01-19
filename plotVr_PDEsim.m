clear all;

datapath1 ='test8/'; total_nsim = 18;

datapathVr = strcat('~/Documents/simudataKorolevgroup/simudataPDE/',datapath1);

figure; hold on;
for i = 1:total_nsim
    
    filename = strcat(datapathVr, 'param', num2str(i), '_out/PDEresult.mat')
    load(filename);
    
    plot(r,v_sim, 'bo')
    plot(r,v_theor, 'ro')
 
end
title(strcat('dtfactor=',num2str(dtfactor)));

