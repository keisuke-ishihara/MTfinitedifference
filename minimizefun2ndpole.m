close all;

global vg vs fcat fres r
vg = 30; vs = 40; fcat = 3; fres = 1;
% vg = 1; vs = 1; fcat = 1; fres = 1;
rs = 0.1:0.1:(fcat*0.999);

% options = optimoptions('lsqnonlin','Display','none');
options = optimoptions('fsolve','Display','none');
x0 = [-0.1 0.1];
% lb = [-vs -inf];
% ub = [+vg inf];
Vs = zeros(1,length(rs));

for i = 1:length(rs)
    
    r = rs(i);
    fun = @fun2ndpole;
    x = fsolve(fun,x0,options);
    Vs(i) = -x(1)/x(2);
    
%     x = lsqnonlin(fun,x0,lb,ub,options);
%     Vs(i) = x(1);
    
end

hold on;
plot(rs,Vs, '.')
plot(fcat-vg/vs*fres,0,'r*')
plot((sqrt(fcat)-sqrt(vg/vs*fres))^2,0,'k*')