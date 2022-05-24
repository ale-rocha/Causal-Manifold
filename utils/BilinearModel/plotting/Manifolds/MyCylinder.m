function MyCylinder(cloud)

    figure
    hold on

    h = 20;
    r = 1;
    
    theta = linspace(0,2*pi,80);%fase 
    v = linspace(0,h,50);  %frecuencia
    [theta,v] = meshgrid(theta,v);
    x = r*cos(theta);
    y = r*sin(theta);
    z=v;

    %Plotting
    s = surf(x,y,z,'FaceAlpha',0.4);
    s.EdgeColor = 'none';
    %colormap(spring);
    colormap(winter);

    %--------------------------------
    %Plotting points
    
    points = cloud.Points;
    [x,y,z] = cylindrical_to_cartesian(points); 
    view(2)
    markerColors = hsv(length(x));
    scatter3(x,y,z,60,markerColors,"filled");
    shg;    
end

