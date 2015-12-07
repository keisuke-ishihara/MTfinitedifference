close all;

global vg vs fcat fres r
vg = 30; vs = 42; fcat = 3.3; fres = 1;
% vg = 1; vs = 1; fcat = 1; fres = 1;
rs = 0.1:0.1:(fcat*0.999);

% options = optimoptions('lsqnonlin','Display','none');
options = optimoptions('fsolve','Display','none');
x0 = [0];
% lb = [-vs -inf];
% ub = [+vg inf];
Vs = zeros(1,length(rs));

for i = 1:length(rs)
    
    r = rs(i);
    fun = @fun2ndpole;
    s = fsolve(fun,x0,options);
    
    b = vg*fres-vs*fcat+vs*r;
    Q=returnqplus(s);
    k = (b+(vg-vs))/vg/vs-Q(1);
    Vs(i) = -s/k;
    
%     x = lsqnonlin(fun,x0,lb,ub,options);
%     Vs(i) = x(1);
    
end

hold on;
plot(rs,Vs, '.')
plot(fcat-vg/vs*fres,0,'r*')
plot((sqrt(fcat)-sqrt(vg/vs*fres))^2,0,'k*')