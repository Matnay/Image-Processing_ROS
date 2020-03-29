img_1=imread('linkoln.jpg');
[r,c]=size(img_1);
img_2=im2bw(img_1,0.3);
se=strel('cube',4);
img_3=imerode(img_2,se);
img_4=img_2-img_3;
subplot(1,2,1),imshow(img_1);
subplot(1,2,2),imshow(im2uint8(img_4));
