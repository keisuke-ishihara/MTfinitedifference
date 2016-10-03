load('param.mat')
fileID = fopen('out.txt','w');
fprintf(fileID,'%s',strcat('hello world ',num2str(a)));