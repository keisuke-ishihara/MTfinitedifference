clc;

v1   = 30;   v2   = 15;
fcat = 3;
r = 0.02:0.01:0.1;

fresc = v2/v1*fcat-sqrt(r*v2/v1*(v1+v2));
Jc = (v1*fresc-v2*fcat)./(fcat+fresc)
[r; (v2+Jc)./v2]
