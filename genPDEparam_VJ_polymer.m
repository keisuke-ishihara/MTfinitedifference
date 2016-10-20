clear all;

dirname = '20161015_VJ_vg30vs15_test3_rpoint07';
old = pwd();

cd experimentsPDE

if exist(dirname) ~= 0
    rmdir(dirname, 's');    
end

mkdir(dirname);
cd(dirname);

% variation = [-15 -8.5 -5 0 5 10 16 23];
% variation = [-40 -27 -14 -8 0 8 16 23];
variation = [-28 -21 -13 -8.8 -4.5 0 8 16 23];
% variation = [-15:1.5:9 12 15 18 21];
variation = [-14.6 -12 -9.4 -6.8];
variation = [-15:2.6:0.6 5.6:7:25];

for i = 1:length(variation)
   
    global v1 v2 fcat fres r
    v1   = 30;   v2   = 15; 
    fcat = 3;
    r = 0.07;
    
    if variation(i) == -v2
        fres = 0;
    else
        fres = (v2+variation(i))/(v1-variation(i))*fcat;
    end
    [i variation(i) fres]
    
    cd(old);
    [r_c, v_theor, J, v_gap] = theoreticalnewpole(v1,v2,fcat,fres,r);
    cd('experimentsPDE');
    cd(dirname);
    
    global tmax xmax dtfactor dim;
    dtfactor = 0.1;
    dim = 1;
    
    nucmode = 2;
    tmax = 26*3; xmax = 700*3;

    save(strcat('param',num2str(i),'.mat'));

end

cd ..
cd ..
