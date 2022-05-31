function ScatterProjection(cloud,namesPro)

    for p = 1:length(get(cloud,"Projections"))
        
        %Get projection
        tempProjection = get(cloud,"Projections");
        tempProjection = tempProjection(p);
        names = get(tempProjection,"NameRelations");
        disp(names);
        
        %Get x and y
        X = get(tempProjection,"X");
        Y = get(tempProjection,"Y");
        
        %plot
        figure;
        c = linspace(1,50,length(X));
        scatter(X,Y,60,c,"filled")
        title(namesPro(p));
        shg;
        
    end

end
