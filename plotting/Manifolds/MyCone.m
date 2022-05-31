function MyCone(cloud)

    figure
    hold on
    
    u = linspace(0,20);     %frecuencia
    q = linspace(0,2*pi);   %FAse
    [U,Q] = meshgrid(u,q);
    %X = 3*cot(fic)-(U.*cos(Q))*cos(fic);
    %X = (U.*cos(Q))*cos(fic);
    %Y = (U.*sin(Q))*cos(fic);
    %Z = U*sin(fic);
    X = (U.*cos(Q));
    Y = (U.*sin(Q));
    Z = U;
    W = U;
    
    %Plotting
    s = surf(X,Z,W,'FaceAlpha',0.4);
    s.EdgeColor = 'none';
    %colormap(spring);
    colormap(winter);
    shg;
   
    %--------------------------------
    %Plotting points
    
    view(2)
    points = cloud.Points;
    [x,y,z] = conical_to_cartesian(points); 
        
    % Define the two colormaps.
    %cmap1 = hot(15);
    %cmap2 = winter(15) ;
    % Combine them into one tall colormap.
    %combinedColorMap = [cmap1; cmap2];
    % Pick 15 rows at random.
    %randomRows = randi(size(combinedColorMap, 1), [length(x), 1]);
    markerColors = hsv(length(x));
   
    scatter3(x,y,z,60,markerColors,"filled");
    
    
    
    shg;
    
    
    %Plottting points
    
end

