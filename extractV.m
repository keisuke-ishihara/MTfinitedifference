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

%% proportion of max method

pos = []; val = [];

for i = 1:length(t)
    pnow = p(:,i);
    
    [Y, I] = max(pnow);

% this was used for plus end stim.    
    if carry~= -1
        pnow(1:I) = Y*ones(1,I);
    end
    
    if carry == -1
        hm = Y;
    elseif carry < 0
        hm = ratio*0.09;
    elseif carry < 1
        hm = ratio*carry;
    elseif carry ==1
        hm = ratio*1;
    end

    [M I] = min(abs(pnow-hm));
    
    if I > 5
        [Y, I] = max(pnow);
    end
    
%     pos = [pos x(I)];
%     val = [val pnow(I)];    
    
    % this was used for polymer stim.    

%     if I < 5
%         hm = ratio*carry;
%         [M I] = min(abs(pnow-hm));
%     end
    
    pos = [pos x(I)];
    val = [val pnow(I)];    
  
end

% plot(pos)
% stop

PS = polyfit(t(end-10:end),pos(end-10:end),1);
% PS = polyfit(t(end-40:end-20),pos(end-40:end-20),1);
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

