% a = log(sump(ceil(end/2):end,end-20:end));
a = log(sump(:,end-20:end));

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
plot(-cut, vels, 'r.', -cut, v_theor,'b.')
title(num2str(r));


% v_theors2

