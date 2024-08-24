function [header,feature,index,filename, pathname] = read_feature()

pathname = [];
filename = [];

[filename, pathname] = uigetfile({';*.txt','Supported Files';...
                   '*.txt','Text (*.txt)';...
                   '*.*','All files (*.*)'},'Select Feature',pathname);

%%
fid = fopen([pathname filename],'r');



header = fscanf(fid, '%d %d %d', [3 1]);
for i = 4:3+header(3)
    header(i) = fscanf(fid, '%d',1);
end

feature = fscanf(fid, '%lf %lf', [2 inf])';

index = [];
for i = 1:header(3)
    
    for j = 1:header(i+3)
        index = [index; i];
    end
end

fclose(fid);