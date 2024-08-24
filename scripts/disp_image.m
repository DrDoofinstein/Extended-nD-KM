function [fig_num] = disp_image(N, r, c, C, U_mag, data, fig_num)

pix = sqrt(N);
img = zeros(r,c,3);
img_o = zeros(r,c);

maxU = max(U_mag);
index1 = find(U_mag(1,:) == maxU);
index2 = find(U_mag(2,:) == maxU);

if C == 3
    index3 = find(U_mag(3,:) == maxU);
end

len = size(index1');
for i = 1 : len(1,1)
    ro = floor(index1(i)/c)+1;
    co = mod(index1(i),c)+1;
    img(ro,co,3) = 1;
    img_o(ro,co) = data(index1(i),1);
end

len = size(index2');
for i = 1 : len(1,1)
    ro = floor(index2(i)/c)+1;
    co = mod(index2(i),c)+1;
    img(ro,co,1) = 1;
    img_o(ro,co) = data(index2(i),1);
end

if C == 3
    len = size(index3');
    for i = 1 : len(1,1)
        ro = floor(index3(i)/c)+1;
        co = mod(index3(i),c)+1;
        img(ro,co,2) = 1;
        img_o(ro,co) = data(index3(i),1);
    end
end

% green1 = find(img(230,170,:));
% green2 = find(img(230,180,:));
% green3 = find(img(230,190,:));
% 
% green = round((green1 + green2 + green3)/3);
% 
% blue1 = find(img(20,40,:));
% blue2 = find(img(30,40,:));
% blue3 = find(img(30,50,:));
% 
% blue = round((blue1 + blue2 + blue3)/3);
% 
% red = 6 - (green+blue);
% if red < 1;
%     red = 1;
%     blue = 3;
%     green = 2;
% end
% 
temp = img;
% 
% img(:,:,1) = temp(:,:,red);
% img(:,:,2) = temp(:,:,green);
% img(:,:,3) = temp(:,:,blue);

fig_num = fig_num + 1;
figure(fig_num);
imshow(img);

I = rgb2gray(img);

change = I<0.15;
I(change) = 0;
change = I>0.4;
I(change) = 1;

fig_num = fig_num + 1;
figure(fig_num);
imshow(I);

temp = 0*temp;
temp(:,:,3) = img(:,:,1);
temp(:,:,2) = img(:,:,3);
temp(:,:,1) = img(:,:,2);
img = temp;

fig_num = fig_num + 1;
figure(fig_num);
imshow(img);

I = rgb2gray(img);

fig_num = fig_num + 1;
figure(fig_num);
imshow(I);

change = I<0.15;
I(change) = 0;
change = I>0.4;
I(change) = 1;

fig_num = fig_num + 1;
figure(fig_num);
imshow(I);



