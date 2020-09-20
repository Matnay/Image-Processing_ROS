frame =imread('cameraman.tif');
I =double(frame);
imshow(frame);
k = waitforbuttonpress;
point1 = get(gca,'CurrentPoint');
rectregion = rbbox; 
point2 = get(gca,'CurrentPoint');
point1 = point1(1,1:2);
point2 = point2(1,1:2);
lowerleft = min(point1, point2);
upperright = max(point1, point2); 
ymin = round(lowerleft(1)); 
ymax = round(upperright(1));
xmin = round(lowerleft(2));
xmax = round(upperright(2));
Aj=6;
cmin=xmin-Aj; cmax=xmax+Aj; rmin=ymin-Aj; rmax=ymax+Aj;
min_N=12;max_N=16;


dx = [-1 0 1; -1 0 1; -1 0 1]; % The Mask 
    dy = dx';

    Ix = conv2(I(cmin:cmax,rmin:rmax), dx, 'same');   
    Iy = conv2(I(cmin:cmax,rmin:rmax), dy, 'same');
    g = fspecial('gaussian',max(1,fix(6*sigma)), sigma);
   
    Ix2 = conv2(Ix.^2, g, 'same');  
    Iy2 = conv2(Iy.^2, g, 'same');
    Ixy = conv2(Ix.*Iy, g,'same');
  
    k = 0.04;
    R11 = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;
    R11=(1000/max(max(R11)))*R11;
    R=R11;
    ma=max(max(R));
    sze = 2*r+1; 
    MX = ordfilt2(R,sze^2,ones(sze));
    R11 = (R==MX)&(R>Thrshold); 
    count=sum(sum(R11(5:size(R11,1)-5,5:size(R11,2)-5)));
    
    
    loop=0;
    while (((count<min_N)|(count>max_N))&(loop<30))
        if count>max_N
            Thrshold=Thrshold*1.5;
        elseif count < min_N
            Thrshold=Thrshold*0.5;
        end
        
        R11 = (R==MX)&(R>Thrshold); 
        count=sum(sum(R11(5:size(R11,1)-5,5:size(R11,2)-5)));
        loop=loop+1;
    end
    
    
	R=R*0;
    R(5:size(R11,1)-5,5:size(R11,2)-5)=R11(5:size(R11,1)-5,5:size(R11,2)-5);
	[r1,c1] = find(R);
    PIP=[r1+cmin,c1+rmin]%% IP 
   
   
   Size_PI=size(PIP,1);
   for r=1: Size_PI
   I(PIP(r,1)-2:PIP(r,1)+2,PIP(r,2)-2)=255;
   I(PIP(r,1)-2:PIP(r,1)+2,PIP(r,2)+2)=255;
   I(PIP(r,1)-2,PIP(r,2)-2:PIP(r,2)+2)=255;
   I(PIP(r,1)+2,PIP(r,2)-2:PIP(r,2)+2)=255;
   
   end
   
   imshow(uint8(I))
