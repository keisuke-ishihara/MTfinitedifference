clear all;

dirname = '20161013_Vr_vg30vs15frespoint3_test5';
old = pwd();

cd experimentsPDE

if exist(dirname) ~= 0
    rmdir(dirname, 's');    
end

mkdir(dirname);
cd(dirname);

% polymer stimulated nucleation parameters

%% polymer stimulated

% variation = [0.01:0.02:0.29];
variation = [0.02:0.04:0.38];
variation = [0.02:0.025:0.37]; % for fres .1
variation = [0.02:0.03:0.35]; % for fres .3

for i = 1:length(variation)
   
    global v1 v2 fcat fres r
    v1   = 30;   v2   = 15;
    fcat = 3;    fres = .3;
    r = variation(i);        % rate of nucleation
%     r = 0;
        
    cd(old);
    [r_c, v_theor, J, v_gap] = theoreticalnewpole(v1,v2,fcat,fres,r);
    cd('experimentsPDE');
    cd(dirname);
    
    global tmax xmax dtfactor dim nucmode;
    dtfactor = 0.1;
    dim = 1;    
    nucmode = 2;
    
    tmax = 26*5; xmax = 800*5;
%     tmax = 28*7; xmax = 820*7;

%     dtfactor = variation(i);
%     tmax = 10*variation(i);
%     xmax = 50*variation(i);
    
%       
%     if r > r_c
%         tmax = 16;
%         xmax = v_theor*tmax + 100;
%     else
%         tmax = 200;
%         xmax = sqrt(v1*v2/(fcat+fres)*tmax*1.2);
%     end

    save(strcat('param',num2str(i),'.mat'));

end

cd ..
cd ..
