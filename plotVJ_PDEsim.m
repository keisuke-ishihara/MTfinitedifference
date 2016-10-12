function [Js, v_sims] = plotVr_PDEsim(datapath1,sims)

% datapath1 ='20160222_test_VJ5/'; sims = 1:8;
% datapath1 ='20160226_test_VJ_vs40/'; sims = 1:5;
datapath1 = '20160305_long8_vgvs30VJ/'; sims = 4:7;

% polymer stimulated
datapath1 = '20161005_VJ_test2_rpoint1/'; sims = 1:7;
datapath1 = '20161005_VJ_test3_rpoint1/'; sims = 1:13;
datapath1 = '20161005_VJ_test6_rpoint1/'; sims = 2:16;

datapath1 = '20161010_VJ_test3_rpoint1/'; sims = 1:16;
datapath1 = '20161010_VJ_test3_rpoint1_dt08/'; sims = 1:16;

datapathVr = strcat('~/Documents/simudataKorolevgroup/simudataPDE/',datapath1);

ratios = 10.^(-.3010:-.02:-1.301);
v_theors = [];
Js = [];
v_sims = [];

for i = 1:length(sims)
    
    filename = strcat(datapathVr, 'param', num2str(sims(i)), '_out/PDEresult.mat');
    load(filename);
    [v1 v2 fcat fres r];
    
    [a1, a2, a3, a4] = theoreticalnewpole(v1,v2,fcat,fres,r);
    n = 1;

    carry = 1-a1/r;
    
    if r == 0
        carry = -1;
    end
       
    vs = [];
    for j = 1:length(ratios)
        curr_ratio = ratios(j);
        [v_sim] = extractV(x, tpoints, sumgrw, dim, n, carry, curr_ratio);
        vs = [vs, v_sim];        
    end
    
    pnow = sumgrw(:,100)/(x(end)-x(end-1));
    
    figure; hold on;
    plot(x,sumgrw(:,90)/(x(end)-x(end-1)));
    plot(x,sumgrw(:,80)/(x(end)-x(end-1)));
    plot(x,sumgrw(:,70)/(x(end)-x(end-1)));

    plot(x,sumgrw(:,40)/(x(end)-x(end-1)));
    plot(x,sumgrw(:,30)/(x(end)-x(end-1)));
    plot(x,sumgrw(:,20)/(x(end)-x(end-1)));
    
%     figure(100); hold on;
%     plot(log10(ratios), vs, 'b');
%     xlabel('log10(thres)'); ylabel('v simu');
%     plot(log10(linspace(min(ratios),max(ratios),100)), a2*ones(100,1), 'r')
%     [J mean(vs) std(vs) std(vs)/mean(vs)]

    v_theors = [v_theors a2];   
    
%     figure(101); hold on;
%     plot(J,mean(vs), 'bo')

    Js = [Js J];
    v_sims = [v_sims mean(vs)];

end

[v1 v2 fcat fres r]

% [Js; v_sims]
figure(101); hold on; plot(Js, v_sims, 'o')
xlabel('mean poly J'); ylabel('aster velocity V')

fresc = v2/v1*fcat-sqrt(r*v2/v1*(v1+v2));
Jc = (v1*fresc-v2*fcat)/(fcat+fres)

fresc2 = -v2/v1*fcat+sqrt(r*v2/v1*(v1+v2));
Jc2 = (v1*fresc2-v2*fcat)/(fcat+fres);

fresb = v2/v1*fcat-r*v2/fcat;
Jb = (v1*fresb-v2*fcat)/(fcat+fres)
plot(Jc, 0, 'r*', Jb, 0, 'k*')

end


% fress = [0:0.005:0.9 0.95:0.05:1.8 2:0.2:6 6.4:0.4:9.6 10 12 15 20 25 40 70 100];
% v_theors = zeros(1,length(fress));
% Js = zeros(1,length(fress));
% 
% for i = 1:length(fress)
%     [a1 a2 a3 a4] = theoreticalnewpole(v1,v2,fcat,fress(i),r);
%     Js(i) = a3;
%     v_theors(i) = a2;
% end
% 
% figure(101); hold on;
% plot(Js,v_theors,'r')

% figure(102); hold on;
% plot(fress,v_theors,'r.')

% figure(5); hold on;
% plot(rs, v_theors, 'r*')

% title(strcat('dtfactor=',num2str(dtfactor)));
