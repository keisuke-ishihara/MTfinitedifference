function [velocity ] = extractV(x, tpoints, sump)
%EXTRACTV
% calculates the velocity of the expansion from simulation curves

n = 10;
t = tpoints(end-n+1:end);
p = sump(:,end-n+1:end);

% % largest decrease method
% 
% pos = []; val = [];
% for i = 1:length(t)
%     pnow = p(:,i);
%     [M I] = max(-diff(pnow'));
%     pos = [pos x(I)];
%     val = [val pnow(I)];
% end

% half max method

pos = []; val = [];
for i = 1:length(t)
    pnow = p(:,i);
    hm = 0.5*max(pnow);
    [M Imax] = max(pnow);
    pnow(1:Imax) = zeros(1,Imax); 
    [M I] = min(abs(pnow-hm));
    pos = [pos x(I)];
    val = [val pnow(I)];
end

% % loglog method
% pos = []; val = [];
% for i = 1:length(t)
% %     pnow = p(:,i);
%     pnow = p(:,end);
%     
% %     hm = 0.5*max(pnow);
% %     [M I] = min(abs(pnow-hm));
%     hm = 0.5*max(pnow);
%     [M I] = min(abs(pnow-hm));
%   
%     pos = [pos x(I)];
%     val = [val pnow(I)];
%      
%     figure; hold on;
%     plot(x,pnow);
%     plot(x(I),pnow(I),'r*');
% end

figure(2); hold on;
plot(x, p(:,end/2:end))
plot(pos, val, 'r*' )

PS = polyfit(t,pos,1);
figure(3); hold on;
plot(t,pos, 'k*')
plot(t,t*PS(1)+PS(2),'r')

velocity = PS(1);

end

