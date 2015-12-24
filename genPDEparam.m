dirname = 'test7';

old = pwd();

cd experimentsPDE

if exist(dirname) ~= 0
    rmdir(dirname, 's');    
end

mkdir(dirname);
cd(dirname);

variation = [0:0.4:1.6 2:0.05:2.4 2.5:0.3:3.4];
% variation = [0:1:3];

for i = 1:length(variation)
   
    global v1 v2 fcat fres r
    v1   = 30;   v2   = 40; 
    fcat = 3;    fres = 1;
    r = variation(i);        % rate of nucleation
    
    cd(old);
    [r_c, v_theor, J, v_gap] = theoreticalnewpole(v1,v2,fcat,fres,r);
    cd('experimentsPDE');
    cd(dirname);
    
    global tmax xmax dtfactor dim;
    dtfactor = 0.05;
    dim = 1;
    
    tmax = 16;
    xmax = 500;
    
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
