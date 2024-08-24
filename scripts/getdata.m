function [feature N r c] = getdata(dim)

pathname = [];

[filename, pathname] = uigetfile({'*.jpg','Supported Files';...
                   '*.*','All files (*.*)'},'Select Image',pathname);
img = imread(strcat(pathname,filename));
figure;
imshow(img);

dimension = size(img);
r = dimension(1);
c = dimension(2);
N = r*c;

feature = zeros(r*c,dim);
n = 1;
for i = 1 : r
    for j = 1 : c
        feature(n,1) = img(i,j);
        n = n + 1;
    end
end

[filename, pathname] = uigetfile({'*.jpg','Supported Files';...
                   '*.*','All files (*.*)'},'Select Image',pathname);
img = imread(strcat(pathname,filename));
figure;
imshow(img);

n = 1;
for i = 1 : r
    for j = 1 : c
        feature(n,2) = img(i,j);
        n = n + 1;
    end
end
