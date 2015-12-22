dirname = 'test1';

cd experimentsPDE

if exist(dirname) ~= 0
    rmdir(dirname, 's');    
end

mkdir(dirname);
cd(dirname);

clear all;
% variation = [0:0.25:3];
variation = [0:1:3];

for i = 1:length(variation)
   
    global v1 v2 fcat fres;
    v1   = 30;   v2   = 40; 
    fcat = 3;    fres = 1;

    global tmax xmax dtfactor dim;
    tmax = 16;
    xmax = 500;
    dtfactor = 0.05;
    dim = 1;
    
    global r
    r = variation(i);        % rate of nucleation

    save(strcat('param',num2str(i),'.mat'));

end

cd ..
cd ..
