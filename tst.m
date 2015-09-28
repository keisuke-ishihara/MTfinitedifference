a = log(sump(ceil(end/2):end,end-20:end));

cut = [-1:-1:-701];


[H W] = size(a);
dx = x(2)-x(1);
dt = tpoints(2)-tpoints(1);

vels = []; vel =[];
for i = 1:length(cut)
    
    b = cut(i)*ones(H,W);
   
    d = (a-b).^2;

    [Y I] = min(d,[],1);
    
    vel = dx*mean(diff(I))/dt;
    vels =[vels vel];
    
end

figure;
% subplot(1,2,1)
% plot(-cut, vels, 'r.', -cut, sqrt(4*(v1*v2)/(fcat+fres)*r)/(1+0.5*r/fcat)*ones(1,length(vels)),'b')
plot(-cut, vels, 'r.', -cut, vt2,'b.')
title(num2str(r));


% v_theors2

