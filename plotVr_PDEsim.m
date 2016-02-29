function [rs v_sims] = plotVr_PDEsim(datapath1,sims)

% datapath1 ='20160204_9/'; sims = 1:9;
% datapath1 ='20160205_2/'; sims = [1, 3:9];

% datapath1 ='20160209_test_unbounded/'; sims = 1:10;
% datapath1 ='20160209_test_jzero/'; sims = 1:10;

% datapath1 = '20160226_test_newvs40_bounded/'; sims = 1:9;
% datapath1 = '20160226_long2_newvs40_bounded/'; sims = [1 3:9];
% datapath1 = '20160226_test_newvs40_unboundedfcat1/'; sims = 1:9;
% datapath1 = '20160226_long2_newvs40_unbounded/'; sims = 1:9;

% vs = 15 simulations

% datapath1 ='20160221_long_bounded/'; sims = 1:9;
% datapath1 ='20160221_long_unbounded/'; sims = 1:9;

datapathVr = strcat('~/Documents/simudataKorolevgroup/simudataPDE/',datapath1);

% ratios = 10.^(-.7:-.01:-2);
% ratios = 10.^(-.3010:-.02:-3.301);
ratios = 10.^(-.3010:-.02:-1.301);
% ratios = 10.^(-.3010:-.1:-1.301);
v_theors = [];
v_sims = [];
rs = [];

for i = 1:length(sims)
    
    filename = strcat(datapathVr, 'param', num2str(sims(i)), '_out/PDEresult.mat');
    load(filename);
    
    [a1, a2, a3, a4] = theoreticalnewpole(v1,v2,fcat,fres,r);
    n = 1;

    carry = 1-a1/r;
    
    if r == 0
        carry = -1;
    end
    
%     if r<a1
%         carry = -1;
%     end
%     if r>fcat
%         carry = 1.1;
%     end
%     if r == 0
%         carry = 1;
%     end
    
%     carry = v1*fres/v2/fcat;
    
    vs = [];
    for j = 1:length(ratios)
        curr_ratio = ratios(j);
        [v_sim] = extractV(x, tpoints, sumgrw, dim, n, carry, curr_ratio);
        vs = [vs, v_sim];        
    end
    
    pnow = sumgrw(:,100)/(x(end)-x(end-1));
%     carry = 1-a1/r;
%     if carry > 0
%         pnow(pnow>carry) = carry*ones(1,sum(pnow>carry));
%     end
    
    figure; hold on;
    plot(x,pnow);
    plot(x,sumgrw(:,90)/(x(end)-x(end-1)));
    plot(x,sumgrw(:,80)/(x(end)-x(end-1)));
    plot(x,sumgrw(:,30)/(x(end)-x(end-1)));
%     
%     figure(100); hold on;
%     plot(log10(ratios), vs, 'b');
%     xlabel('log10(thres)'); ylabel('v simu');
%     plot(log10(linspace(min(ratios),max(ratios),100)), a2*ones(100,1), 'r')
%     [r mean(vs) std(vs) std(vs)/mean(vs)];
%     v_theors = [v_theors a2];
    
    figure(101); hold on;
    plot(r, mean(vs), 'ko')
        
    v_sims = [v_sims mean(vs)];
    rs = [rs r];
    
%     plot(r,a2, 'r*')

end

rs = linspace(0,1.2*r,1000);
v_theors = zeros(1,length(rs));
for i = 1:length(rs)
    [a1 a2 a3 a4] = theoreticalnewpole(v1,v2,fcat,fres,rs(i));
    v_theors(i) = a2;
end
figure(101); hold on;
plot(rs,v_theors,'r')