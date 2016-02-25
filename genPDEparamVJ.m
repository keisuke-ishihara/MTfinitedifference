clear all;

dirname = '20160222_test_VJ5';
old = pwd();

cd experimentsPDE

if exist(dirname) ~= 0
    rmdir(dirname, 's');    
end

mkdir(dirname);
cd(dirname);

variation = [-15 -8.5 -5 0 5 10 16 23];

for i = 1:length(variation)
   
    global v1 v2 fcat fres r
    v1   = 30;   v2   = 15; 
    fcat = 3;
    r = 1.6;
    
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
    
    tmax = 30; xmax = 900;

    save(strcat('param',num2str(i),'.mat'));

end

cd ..
cd ..
