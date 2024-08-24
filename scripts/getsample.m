function [sample_data] = getsample(data, C, dim)

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

d1 = [];
d2 = [];
d3 = [];

i1 = 1;
i2 = 1;
i3 = 1;

for i = 1 : N
    if feature(i) == 0
        d1(i1) = i;
        i1 = i1 + 1;
    end
    if C == 2
        if feature(i) == 255
            d2(i2) = i;
            i2 = i2 + 1;
        end
    else
        if feature(i) == 128
            d2(i2) = i;
            i2 = i2 + 1;
        end
        if feature(i) == 255
            d3(i3) = i;
            i3 = i3 + 1;
        end
    end
end

sample_data = zeros(200*C, dim);

sample_data(1 : 200, :) = data(d1(randi((i1-1),1,200)),:);
sample_data(201 : 400, :) = data(d2(randi((i2-1),1,200)),:);

figure(4);
hold on;
plot(sample_data(1:200,1),sample_data(1:200,2),'*','color','g');
plot(sample_data(201:400,1),sample_data(201:400,2),'*','color','r');
plot(sample_data(1:200,1),sample_data(1:200,2),'o','color','k');
plot(sample_data(201:400,1),sample_data(201:400,2),'square','color','k');

if C == 3
    sample_data(401 : 600, :) = data(d3(randi((i3-1),1,200)),:);
    plot(sample_data(401:600,1),sample_data(401:600,2),'*','color','b');
    plot(sample_data(401:600,1),sample_data(401:600,2),'diamond','color','k');
end