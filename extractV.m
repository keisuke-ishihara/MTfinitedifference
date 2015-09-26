function [velocity ] = extractV(x, tpoints, sump, dim, n)
%EXTRACTV
% calculates the velocity of the expansion from simulation curves

t = tpoints(end-n+1:end);
p = sump(:,end-n+1:end);
dx = x(2)-x(1);

dt = tpoints(end)-tpoints(end-1);

% normalize the number of plus ends with geometry
if dim == 1
    p_norm = p;
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

%% working... quarter? max method

pos = []; val = [];
ratio = 0.25;
for i = 1:length(t)
    pnow = p(:,i);
    hm = ratio*max(pnow);
    [M Imax] = max(pnow);
    pnow(1:Imax) = zeros(1,Imax);
    [M I] = min(abs(smooth(pnow-hm)));
%     [M I] = min(abs(pnow-hm));
    pos = [pos x(I)];
    val = [val pnow(I)];
end

PS = polyfit(t,pos,1);
% figure(3); hold on;
% plot(t,pos, 'k*')
% plot(t,t*PS(1)+PS(2),'r')

velocity = PS(1);

vone = velocity;

%% area under the curve method

cutoff = 0.01;

i = 1;
pnow = p(:,i);
[M Imax] = max(pnow);
pnow(1:Imax) = 1*ones(1,Imax);
pnow(pnow>cutoff) = cutoff*ones(1,length(pnow(pnow>cutoff)));

v = [];
a = [];
for i = 2:length(t)
    
    pnext = p(:,i);
    [M Imax] = max(pnext);
    pnext(1:Imax) = 1*ones(1,Imax);
    pnext(pnext>cutoff) = cutoff*ones(1,length(pnext(pnext>cutoff)));

    diffarea = sum(pnext)-sum(pnow);
    v = [v diffarea/cutoff/dt*dx];
%     a = [a diffarea];
    
    pnow = pnext;

end

% a = a/a(1);

velocity = v(end);
% velocity = vone;
% velocity = mean(v);
% [vone velocity v]

end

