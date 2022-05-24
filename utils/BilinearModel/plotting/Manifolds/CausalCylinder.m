function CausalCylinder(cloud)

    figure
    hold on
    h = 5;
    r = 1;
   
    for r = 1:6  %Iterando sobre los segundos
        theta = linspace(0,2*pi,80);
        v = linspace(0,h,50);
        [theta,v] = meshgrid(theta,v);
        x = r*cos(theta);
        y = r*sin(theta);
        z=v;
        w=v;

        %Plotting
        s = surf(x,w,z,'FaceAlpha',1/r);
        s.EdgeColor = 'none';
        %colormap(spring);
        colormap(winter);
        
        %------------------------------------
        % Ploteando los puntos 
        %Iterando sobreel numero de puntos
       
        view(2)
        points  = cloud.Points();
        newx = [];
        newy = [];
        newz = [];
        for p = 1:length(points)
            point = points(p);
            Freq = point.CausalFeatures.MeanFrequencies(r);
            Phase = point.CausalFeatures.MeanPhases(r);
            [x,y,z] = conical_to_cartesian_aux(Phase,Freq);
            disp("Ubicaicon x-y")
            disp(x)
            disp(y)
            disp("----------------")
            newx = [newx,(r)*x];
            newy = [newy,(r)*y];
            newz = [newz,abs(z)];
        end
        
        % Define the two colormaps.
        markerColors = hsv(length(newx));
        scatter3(newx,newy,newz,60,markerColors,"filled");
        shg;
    
    
    end
    
    
    %Plotting Minkowsky cone
    %TODO: center in the point
    
    [X,Y,Z]=MinkowskiMetric(pi,2,2);
    scatter3(X,Y,Z,60,"black","filled");
    [x1,y1,z1]=point_cylindrical_to_cartesian(pi,2,2);
    scatter3(x1,y1,z1,120,"red","filled");

    colormap(winter);
    shg;    
end