clear all; clc;

v1   = 30; % polymerization
v2   = 40; % depolymerization
fcat = 3; % catastrophe
fres = 1; % rescue
% rs = [1 2.5];
rs = [2.5];

% v1   = 30; % polymerization
% v2   = 15; % depolymerization
% fcat = 3; % catastrophe
% fres = 1; % rescue
% rs = [2.5];


rcnew = fcat-v1/v2*fres;

% v1   = 1; v2   = 1; fcat = 1; fres = 1;
% rs = [0.1:0.2:0.9]*fcat;

J = (v1*fres-v2*fcat)/(fres+fcat);
D = v1*v2/(fres+fcat);
meanlength = -D/J;

dim = 2;  % dimension of system

tic
v_Fishers = []; v_Holmes = []; v_sims = []; v_KKs = [];
for i = 1:length(rs) 
    
    r = rs(i);
    
    [r_c, v_theor, J] = theoreticalnewpole(v1,v2,fcat,fres,r);
    [x, tpoints, sump, p, q] = sim_plusminus(v1,v2,fcat,fres,r,dim);
%     [x, tpoints, sump, p, q, v_sim] = adaptivesim_plusonly(v1,v2,fcat,fres,r,dim);
    
%     v_sims = [v_sims v_sim];
    v_KKs = [v_KKs v_theor];
    
%     v_Fishers = [v_Fishers sqrt(x4*(v1*v2)/(fcat+fres)*r)];
%     vH = sqrt(4*v1*v2/fcat*r)/(1+r/fcat);
%     if r > fcat
% %     vH = sqrt(4*v1*v2/(fcat+fres)*r)/(1+r/(fcat+fres));
% %     if r > fcat+fres
%         vH = v1;
%     end
%     v_Holmes  = [v_Holmes vH];
    
    dx = x(2)-x(1);

    figure('Position', [1400, 800, 350, 250]); hold on;

    if dim == 1
        
        xindex = 1;
       
        toplot = sump(:,(1:10:81))/dx;
        [grad,im] = colorGradient([0 0.6 1],[1 0.1 0], 1+min(size(toplot)));
    
        % plot initial condition
%         plot(x, sump(:,1)/dx, 'Color', grad(1,:), 'linewidth',1.2);
        
    elseif dim == 2
        
        xindex = sum(x<40);
%         xindex = 1;
        if xindex == 0
            xindex = 1;
        end
        
        toplot = sump(:,(1:10:81))./repmat((2*pi*(x+dx)*dx)',1,9);
        [grad,im] = colorGradient([0 0.6 1],[1 0.1 0], 1+min(size(toplot)));

        % plot initial condition
%         plot(x, sump(:,1)./(2*pi*(x+dx)*dx)', 'Color', grad(1,:), 'linewidth',1.2);
        
    elseif dim == 3
        
        xindex = sum(x<40);
        
        toplot = sump(:,(1:10:81))./repmat((4*pi*(x+dx).^2*dx)',1,9);
        [grad,im] = colorGradient([0 0.6 1],[1 0.1 0], 1+min(size(toplot)));

        % plot initial condition
%         plot(x, sump(:,1)./(2*pi*(x+dx)*dx)', 'Color', grad(1,:), 'linewidth',1.2);

    else
        stop
    end
    
    for imat = 1:min(size(toplot))
%         plot(x, toplot(:,imat), 'Color', grad(imat+1,:), 'linewidth',1.2);
        plot(x(xindex:end), toplot(xindex:end,imat), 'Color', grad(imat+1,:), 'linewidth',1.2);
    end
    
    
%     axis([0 max(x) 0 1.1*(max(sump(:,1)/(x(2)-x(1))))]);
    ax = gca;
%     ax.XTick = [-vs 0 +vg]; ax.XTickLabel = {'-v_{s}', '0', '+v_{g}'};
%     ax.YTick = [0:0.03:0.21];
%     ax.YTickLabel = {'0', '1', '2', '3', '4', '5', '6', '7'};
    
end


stop 

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
% figure('Position', [100, 360, 300, 250]); plot(x,sum(p,2)/(x(2)-x(1)), x,sum(q,2)/(x(2)-x(1)))
% % hold on; plot(x, (sum(p,2)+sum(q,2))/(x(2)-x(1)))
% figure('Position', [100, 10, 300, 250]); plot(x,log(sum(p,2)), x,log(smooth(sum(q,2))))

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