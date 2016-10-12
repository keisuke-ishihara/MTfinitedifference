clear all;

dirname = '20161010_VJ_test3_rpoint1_dt08';
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
variation = [-28:3:26];
variation = [-28:2:2];

for i = 1:length(variation)
   
    global v1 v2 fcat fres r
    v1   = 30;   v2   = 30; 
    fcat = 3;
    r = 0.1;
    
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
    dtfactor = 0.08;
    dim = 1;
    
    nucmode = 2;
    tmax = 28*3; xmax = 850*3;

    save(strcat('param',num2str(i),'.mat'));

end

cd ..
cd ..
