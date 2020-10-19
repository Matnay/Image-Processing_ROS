img_1=imread('moon.tif');
[r,c]=size(img_1);
img_2=zeros(r,c);
img_3=zeros(r,c);
img_4=zeros(r,c);
filter=[-1,-1,-1;0,0,0;1,1,1];
filt=[-1,0,1;-1,0,1;-1,0,1];
i1=im2double(img_1);
for x=2:r-1
    for y=2:c-1
        img_2(x,y)=sum(sum(i1(x-1:x+1,y-1:y+1).*filter));
        img_3(x,y)=sum(sum(i1(x-1:x+1,y-1:y+1).*filt));
        img_4(x,y)=(img_2(x,y)^2+img_3(x,y)^2)^0.5;
    end
end
subplot(1,2,1),imshow(img_1);
subplot(1,2,2),imshow(im2uint8(img_4));
