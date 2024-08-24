function [feature N r c] = hwang_data(dim)

pathname = [];

[filename, pathname] = uigetfile({'*.jpg','Supported Files';...
                   '*.*','All files (*.*)'},'Select Image',pathname);
img = imread(strcat(pathname,filename));
figure(1);
imshow(img);

dimension = size(img);
r = dimension(1);
c = dimension(2);
N = r*c;

feature = zeros(r*c,dim);

for d = 1 : 3
    n = 1;
    for i = 1 : r
        for j = 1 : c
            feature(n,d) = img(i,j,d);
            n = n + 1;
        end
    end
end
