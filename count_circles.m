a = imread('coins.png');
          bw = im2bw(a,0.4);
          bw=imfill(bw,'holes');
          subplot(221),imshow(a);         
          subplot(222),imshow(bw);
          title('Image with Circles')
  
          stats = regionprops('table',bw,'Centroid','MajorAxisLength','MinorAxisLength');
  
          % Get centers and radii of the circles
          centers = stats.Centroid;
          diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
          radii = diameters/2;
  
          % Plot the circles
          hold on
          viscircles(centers,radii);
          hold off
          [number_of_circles,c]=size(centers)