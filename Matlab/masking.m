img_1=imread('moon.tif');
[r,c]=size(img_1);
se=strel('disk',3.0);
img_2=im2bw(img_1,0.4);
img_3=imdilate(img_2,se);
img_2=imclose(img_2,se);
img_d=im2double(img_1);
img_5=zeros(r,c);
for x=1:r
    for y=1:c
        if img_3(x,y)==true
            img_5(x,y)=1;
        else
            img_5(x,y)=0;
        end
    end
end
img_4=img_d.*img_5;
        
subplot(2,2,1),imshow(img_1);
subplot(2,2,2),imshow(im2uint8(img_2));
subplot(2,2,3),imshow(img_3);
subplot(224),imshow(img_4);
