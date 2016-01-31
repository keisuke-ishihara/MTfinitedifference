clear all;
close all;

datapath1 ='test8/'; total_nsim = 18;

datapathVr = strcat('~/Documents/simudataKorolevgroup/simudataPDE/',datapath1);

% ratios = 10.^(-.7:-.01:-2);
ratios = 10.^(-.3010:-.01:-1.301);
v_theors = [];

for i = 1:total_nsim
        
    filename = strcat(datapathVr, 'param', num2str(i), '_out/PDEresult.mat');
    load(filename);
    
    [a1, a2, a3, a4] = theoreticalnewpole(v1,v2,fcat,fres,r);
    n = 1;

    carry = 1-a1/r;
    if r<a1
        carry = -1;
    end
    if r>fcat
        carry = 1.1;
    end
    
    vs = [];
    for j = 1:length(ratios)
        curr_ratio = ratios(j);
        [v_sim] = extractV(x, tpoints, sumgrw, dim, n, carry, curr_ratio);
        vs = [vs, v_sim];        
    end
    
    pnow = sumgrw(:,100)/(x(end)-x(end-1));
    carry = 1-a1/r;
    if carry > 0
        pnow(pnow>carry) = carry*ones(1,sum(pnow>carry));
    end
    
%     figure; hold on;
%     plot(x,pnow);
%     plot(x,sumgrw(:,90)/(x(end)-x(end-1)));
%     plot(x,sumgrw(:,80)/(x(end)-x(end-1)));
%     plot(x,sumgrw(:,70)/(x(end)-x(end-1)));
%     plot(x,sumgrw(:,60)/(x(end)-x(end-1)));
    
    figure(100); hold on;
    plot(log10(ratios), vs, 'b');
    plot(log10(linspace(min(ratios),max(ratios),100)), a2*ones(100,1), 'r')
    [r mean(vs) std(vs) std(vs)/mean(vs)]

    v_theors = [v_theors a2];
    
%     [v_sim] = extractV(x, tpoints, sumgrw, dim, n, 1-a1/r, 0.02);
%     plot(r,v_sim, 'bo')
%     plot(r,v_theor, 'r*')

    figure(101); hold on;
    plot(r,mean(vs), 'bo')
%     plot(r,a2, 'r*')

end

rs = linspace(0,3.5,1000);
v_theors = zeros(1,length(rs));
for i = 1:length(rs)
    [a1 a2 a3 a4] = theoreticalnewpole(v1,v2,fcat,fres,rs(i));
    v_theors(i) = a2;
end
figure(101); hold on;
plot(rs,v_theors,'r')

% figure(5); hold on;
% plot(rs, v_theors, 'r*')

% title(strcat('dtfactor=',num2str(dtfactor)));

