 theta = linspace(0,8*pi,1000);%fase 
 v = linspace(0,6,50);  %frecuencia
 k=1.5;
 [theta,v] = meshgrid(theta,v);
 r = k*theta;
 x = r.*cos(theta);
 y = r.*sin(theta);
 z=v;

 %Plotting
 s = surf(x,y,z,'FaceAlpha',0.4);
 s.EdgeColor = 'none';
 %colormap(spring);
 colormap(winter);


