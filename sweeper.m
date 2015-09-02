clear all; close all;

v1   = 20;  % polymerization
v2   = 16;  % depolymerization
fcat = 3; % catastrophe
fres = 1; % rescue
r    = 0.6; % nucleation rate
dim  = 1;  % dimension of system

[x, tpoints, sump] = solve_advection(v1,v2,fcat,fres,r,dim);

extractV(x,tpoints,sump)


