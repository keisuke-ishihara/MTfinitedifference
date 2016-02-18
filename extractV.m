function [velocity] = extractV(x, tpoints, sump, dim, n, carry, ratio)
%EXTRACTV
% calculates the velocity of the expansion from simulation curves

t = tpoints;
p = sump;
dx = x(2)-x(1);

dt = tpoints(end)-tpoints(end-1);

% normalize the number of plus ends with geometry
if dim == 1
    p_norm = p/dx;
elseif dim == 2
    [a b] = size(p);
    p_norm = p./(repmat(2*pi*x/dx,b,1))';
else
    error
end
p = p_norm;

%% methods 

% % % largest decrease method
% % 
% % pos = []; val = [];
% % for i = 1:length(t)
% %     pnow = p(:,i);
% %     [M I] = max(-diff(pnow'));
% %     pos = [pos x(I)];
% %     val = [val pnow(I)];
% % end

%% proportion of max method

pos = []; val = [];
% ratio = 0.02;
for i = 1:length(t)
    pnow = p(:,i);
    
%     hm = ratio*max(pnow);
%     [M Imax] = max(pnow);
%     pnow(1:Imax) = zeros(1,Imax);
    
    if carry >= 1
%         hm = ratio*max(pnow);
        hm = ratio*0.25;
    elseif carry >= 0
        hm = ratio*carry;
%         pnow(pnow>carry) = carry*ones(1,sum(pnow>carry));
%         hm = ratio*max(pnow);
    else
        hm = ratio*0.09;
%         hm = ratio*max([max(pnow), 1]);
    end
    
%     [M I] = min(abs(smooth(pnow-hm)));
    [M I] = min(abs(pnow-hm));
    pos = [pos x(I)];
    val = [val pnow(I)];    
   
end

PS = polyfit(t(end-20:end),pos(end-20:end),1);
velocity = PS(1);

% figure(5); hold on;
% if ratio == 10^(-1.4)
% %     plot(log(t), pos)
%     plot(t(2:end),diff(pos)/(t(end)-t(end-1)))
% end

% figure; hold on;
% plot(t,pos, 'k*')
% plot(t,t*PS(1)+PS(2),'r')
% title(strcat('ratio=',num2str(ratio),' vsim=',num2str(velocity)));

% figure(2); hold on;
% plot(t(2:end),diff(pos)/dt)
% axis([0 max(t) 0 35])
% % title(strcat('ratio=',num2str(ratio),' vsim=',num2str(velocity)));

% vone = velocity;

end

