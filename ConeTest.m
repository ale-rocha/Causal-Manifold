function ConeTest()

    figure
    hold on
    fic = pi/5;
    u = linspace(0,20);     %frecuencia
    q = linspace(0,2*pi);   %FAse
    [U,Q] = meshgrid(u,q);
    %X = 3*cot(fic)-(U.*cos(Q))*cos(fic);
    %X = (U.*cos(Q))*cos(fic);
    %Y = (U.*sin(Q))*cos(fic);
    %Z = U*sin(fic);
    X = (U.*cos(Q));
    Y = (U.*sin(Q));
    
    Z = U
    surf(X,Y,Z)
    
    fase = 10;
    freq = 2;
    
    X = freq*cos(fase);
    Y = freq*sin(fase);
    Z = freq;
    
    view(2)
    scatter3(X,Y,Z,'o', 'LineWidth',3, ...
        'MarkerFaceColor', 'black', ...
        'MarkerEdgeColor', 'black');
    
    shg;

    shg;
   
end
