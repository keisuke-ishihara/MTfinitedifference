clear all;

v1   = 30; % polymerization
v2   = 40; % depolymerization
fcat = 3.3; % catastrophe
fres = 1; % rescue
% rs = [.9]*fcat;
% rs = [0.3 0.6 0.7 0.8]*fcat;
% rs = [0:0.1:0.6 0.65 0.7 0.725 0.75 0.775 0.8 0.825 0.85 0.9:0.1:1.3]*fcat;
% rs = [0.7 0.725 0.75 0.775 0.8 0.825 0.85 0.9 1 1.2]*fcat;
% rs = [1.0 2.8];
rs = [2.7];

rcnew = fcat-v1/v2*fres;

% v1   = 1; v2   = 1; fcat = 1; fres = 1;
% rs = [0.1:0.2:0.9]*fcat;

J = (v1*fres-v2*fcat)/(fres+fcat);
D = v1*v2/(fres+fcat);
meanlength = -D/J;

dim  = 1;  % dimension of system

tic
v_Fishers = []; v_Holmes = []; v_sims = []; v_KKs = [];
for i = 1:length(rs) 
    
    r = rs(i);
    
    [r_c, v_theor, J] = theoreticalnewpole(v1,v2,fcat,fres,r);
    [x, tpoints, sump, p, q, v_sim] = sim_plusminus(v1,v2,fcat,fres,r,dim);
%     [x, tpoints, sump, p, q, v_sim] = adaptivesim_plusonly(v1,v2,fcat,fres,r,dim);
    
    v_sims = [v_sims v_sim];
    v_KKs = [v_KKs v_theor];
    
%     v_Fishers = [v_Fishers sqrt(x4*(v1*v2)/(fcat+fres)*r)];
%     vH = sqrt(4*v1*v2/fcat*r)/(1+r/fcat);
%     if r > fcat
% %     vH = sqrt(4*v1*v2/(fcat+fres)*r)/(1+r/(fcat+fres));
% %     if r > fcat+fres
%         vH = v1;
%     end
%     v_Holmes  = [v_Holmes vH];
    
    toplot = sump(:,10:floor(end/15):end)/(x(2)-x(1));
    [grad,im] = colorGradient([0 0.6 1],[1 0.1 0], 1+min(size(toplot)));
    
    figure('Position', [500, 100, 350, 250]); hold on;
    plot(x, sump(:,1)/(x(2)-x(1)), 'Color', grad(1,:), 'linewidth',1.2);
    for imat = 1:min(size(toplot))
        plot(x, toplot(:,imat), 'Color', grad(imat+1,:), 'linewidth',1.2);
    end
    
%     run tst
    [r/fcat tpoints(end) toc]

end

% figure('Position', [100, 360, 300, 250]); plot(x,smooth(sump(:,end))/(x(2)-x(1)), x,smooth(q)/(x(2)-x(1)))
% hold on; plot(x, (sump(:,end)+q)/(x(2)-x(1)))
% figure('Position', [100, 10, 300, 250]); plot(x,log(smooth(sump(:,end))), x,log(smooth(q)))
% 
% finers = linspace(0,max(rs),1000);
% v_KKfine = zeros(1,length(finers));
% for i = 1:length(finers)    
%     [r_c, v_theor, J] = theoreticalnewpole(v1,v2,fcat,fres,finers(i));
%     v_KKfine(1,i) = v_theor;
% end
% 
% FigHandle = figure('Position', [500, 100, 1000, 250]);
% subplot(1,3,1); hold on;
% plot(finers/fcat, v_KKfine, 'g', rs/fcat, v_sims, 'ro');
% plot(r_c/fcat,0, 'b*')
% 
% subplot(1,3,2); hold on;
% error = abs(v_sims-v_KKs)./v_KKs;
% plot(rs(rs>r_c)/fcat, error(rs>r_c), 'o', r_c/fcat,0, 'r*'); title('error');
% 
% subplot(1,3,3); hold on;
% normalized = v_sims./v_KKs;
% plot(rs(rs>r_c)/fcat, normalized(rs>r_c), 'o', r_c/fcat,0, 'r*'); title('normalized');
% 
% stop

p(:,1)=zeros(length(p),1);
q(:,1)=zeros(length(q),1);
figure('Position', [100, 360, 300, 250]); plot(x,sum(p,2)/(x(2)-x(1)), x,sum(q,2)/(x(2)-x(1)))
% hold on; plot(x, (sum(p,2)+sum(q,2))/(x(2)-x(1)))
figure('Position', [100, 10, 300, 250]); plot(x,log(sum(p,2)), x,log(smooth(sum(q,2))))

finers = linspace(0,1.2*fcat,1000);
v_KKfine = zeros(1,length(finers));
for i = 1:length(finers)    
    [r_c, v_theor, J] = theoreticalnewpole(v1,v2,fcat,fres,finers(i));
    v_KKfine(1,i) = v_theor;
end
   
[rs'/fcat v_KKs' v_sims'];

use = sum(p,2)+sum(q,2);
simmeanlength = sum((1:length(use)).*use')/sum(use)*(x(2)-x(1));
[simmeanlength meanlength];

r = finers;
s = 2*r.^2./(1-r.^2);
k = r-sqrt(s.^2+2*s);
V_first  = (2*r-r.^2+sqrt(r).*r)./(sqrt(r).*(2-r)+r.^2); 
V_second = -s./k;
V_second2 = 2*r./(r.^2+1);
V_tele = sqrt(4*r/2)./(1+r/2); 

% FigHandle = figure('Position', [500, 100, 1000, 250]);
% subplot(1,3,1); hold on;
% plot(finers/fcat, v_KKfine, 'g', rs/fcat, v_sims, 'ro');

figure; hold on
plot(rs/fcat, v_sims, 'ro');
plot(rcnew/fcat,0, 'b*')
axis([0 max(rs)*1.05/fcat 0 v1*1.1])

Tickfontsize = 16;
Labelfontsize = 20;
ax = gca;
% ax.XTick = [0]; ax.XTickLabel = {0};
% ax.YTick = [0 vg]; ax.YTickLabel = {'0', '+ v_{g}'};
ax.FontSize = Tickfontsize;
ax.FontWeight = 'Bold';
xlabel('normalized nucleation','Fontsize',Labelfontsize)
ylabel('aster expansion rate','Fontsize',Labelfontsize)


stop

% plot(finers/fcat, V_first, 'b', finers/fcat, V_second, 'r',finers/fcat, V_tele, 'g', rs/fcat, v_sims, 'ko');
% plot(finers/fcat, V_first, 'b', finers/fcat, V_second, 'r', rs/fcat, v_sims, 'ko');
% axis([0 1 0 1]);

subplot(1,3,2); hold on;
error = abs(v_sims-v_KKs)./v_KKs;
plot(rs(rs>r_c)/fcat, error(rs>r_c), 'o', r_c/fcat,0, 'r*'); title('error');

subplot(1,3,3); hold on;
normalized = v_sims./v_KKs;
plot(rs(rs>r_c)/fcat, normalized(rs>r_c), 'o', r_c/fcat,0, 'r*'); title('normalized');