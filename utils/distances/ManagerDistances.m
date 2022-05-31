
function vec_manager_distancesFinal = ManagerDistances(cloud,norms)
    vec_manager_distancesFinal = [];
    % P - NORMS
    for n = 1:length(norms)
        vec_manager_distances = [];
        if norms(n) == "pnorm1" || norms(n) == "pnorm2" || norms(n) == "pnorm5"
            disp("Calculando distancia pnorm")
            vec_manager_distances = [vec_manager_distances,MatrixDistances(cloud, norms(n))];
        end
        if norms(n) == "cosine"
            disp("Calculando distancia cosine")
            vec_manager_distances = [vec_manager_distances, MatrixDistancesCosine(cloud, norms(n))];
        end
        if norms(n) == "correlation"
            disp("Calculando distancia correlation")
            vec_manager_distances = [vec_manager_distances, MatrixDistancesCorrelaton(cloud, norms(n))];
        end
        if norms(n) == "cylindrical" || norms(n) == "geodesical"
            disp("Calculando distancia geodesical")
            vec_manager_distances = [vec_manager_distances, MatrixDistancesCylindrical(cloud, norms(n))];
        end
        vec_manager_distancesFinal = [vec_manager_distancesFinal, vec_manager_distances];
    end
end

function obj_distancia = MatrixDistancesCylindrical(cloud, norm)
  obj_distancia = MatrixDistance;
  distancias = [];
  names = [];
  
  %Extract phases and frequencies from objects
  points = get(cloud,"Points");
  
  for p1 = 1:length(points)
    for p2 = 1:length(points)
        serie1_Phase = get(points(p1),"Phase");
        serie2_Phase = get(points(p2),"Phase");
        serie1_Freq = get(points(p1),"Frequency");
        serie2_Freq = get(points(p2),"Frequency");
        
        %Cambiar a coordenadas cartesianas
        
        
        [x1,y1,z1] = conical_to_cartesian_aux(serie1_Phase, serie1_Freq);
        [x2,y2,z2] = conical_to_cartesian_aux(serie2_Phase, serie2_Freq);
        
        %if (serie1_Phase-serie2_Phase)  < 1
             %Cdistance   =  power((x1-x2),1)+(power(y1 - y2,1))+(power(z1 - z2,1));
             %Cdistance   =  1/(abs(sin(serie1_Phase)) + abs(cos(serie2_Phase) ));
        %else
             %Cdistance   =  power(1-(x1-x2),1)+(power(y1 - y2,1))+(power(z1 - z2,1));
             %Cdistance   =  1/(abs(sin(serie1_Phase)) + abs(cos(serie2_Phase) ));
        %end
        Cdistance   =   (power((abs(serie1_Phase-serie2_Phase)),2)+(power(abs(serie1_Freq - serie2_Freq),2)));
        Cdistance = power(Cdistance,1/2);
        distancias = [distancias,abs(Cdistance)];
        %Name distances: example "point1-point2"
        name_distance = strcat(int2str(get(points(p1),"Id")) ,"-");
        name_distance = strcat(name_distance, int2str(get(points(p2),"Id")));
        names = [names,name_distance];
    end
  end
  
  %Reshape to N x N
  distancias = reshape(distancias,length(points),length(points));
  disp(distancias)
  obj_distancia.Matrix = distancias;
  obj_distancia.Name = norm;
  obj_distancia.NameRelations = names;

end

function obj_distancia = MatrixDistancesCorrelaton(cloud, norm)
  obj_distancia = MatrixDistance;
  distancias = [];
  names = [];
  
  %Extract phases and frequencies from objects
  points = get(cloud,"Points");
  
  for p1 = 1:length(points)
    for p2 = 1:length(points)
        serie1 = get(points(p1),"TimeSerie");
        serie2 = get(points(p2),"TimeSerie");
        
        Cdistance   =corrcoef(serie1,serie2);
        Rc = Cdistance(1,2);
        distancias = [distancias,abs(Rc)];
        %Name distances: example "point1-point2"
        name_distance = strcat(int2str(get(points(p1),"Id")) ,"-");
        name_distance = strcat(name_distance, int2str(get(points(p2),"Id")));
        names = [names,name_distance];
    end
  end
  disp("Sixe matrix problem correlation ")
  disp(size(distancias))
  disp(distancias)
  %Reshape to N x N
  distancias = reshape(distancias,length(points),length(points));
  disp(distancias)
  obj_distancia.Matrix = distancias;
  obj_distancia.Name = norm;
  obj_distancia.NameRelations = names;

end


function obj_distancia = MatrixDistancesCosine(cloud, name)
  obj_distancia = MatrixDistance;
  distancias = [];
  names = [];
  
  %Extract phases and frequencies from objects
  points = get(cloud,"Points");
  
  for p1 = 1:length(points)
    for p2 = 1:length(points)
        serie1 = get(points(p1),"TimeSerie");
        serie2 = get(points(p2),"TimeSerie");
        
        xy   = dot(serie1,serie2);
        nx   = norm(serie1);
        ny   = norm(serie2);
        nxny = nx*ny;
        Cs   = xy/nxny;
        distancias = [distancias,abs(Cs)];
        %Name distances: example "point1-point2"
        name_distance = strcat(int2str(get(points(p1),"Id")) ,"-");
        name_distance = strcat(name_distance, int2str(get(points(p2),"Id")));
        names = [names,name_distance];
    end
  end
  
  %Reshape to N x N
  distancias = reshape(distancias,length(points),length(points));
  disp("Matrix distancias Coseno")
  disp(size(distancias))
  disp(distancias)
  obj_distancia.Matrix = distancias;
  obj_distancia.Name = name;
  obj_distancia.NameRelations = names;

end

function obj_distancia = MatrixDistances(cloud, norm)

  obj_distancia = MatrixDistance;
  p = CheckNorm(norm);
  distancias = [];
  names = [];
  
  %Extract phases and frequencies from objects
  points = get(cloud,"Points");
  
  for p1 = 1:length(points)
    for p2 = 1:length(points)
        serie1 = get(points(p1),"TimeSerie");
        serie2 = get(points(p2),"TimeSerie");
        
        %Calculando distancias
        distBWpoints = sum(power(abs(serie1 - serie2),p));
        distancias = [distancias,distBWpoints];
        %Name distances: example "point1-point2"
        name_distance = strcat(int2str(get(points(p1),"Id")) ,"-");
        name_distance = strcat(name_distance, int2str(get(points(p2),"Id")));
        names = [names,name_distance];
    end
  end
  
  %Reshape to N x N
  distancias = reshape(distancias,length(points),length(points));
  disp(distancias)
  obj_distancia.Matrix = distancias;
  obj_distancia.Name = norm;
  obj_distancia.NameRelations = names;
  
end

function p = CheckNorm (norm)
    if (norm == "pnorm1")
        p = 1;
    end
    if (norm == "pnorm2")
        p = 2;
    end
    if (norm == "pnorm5")
        p = 5;
    end
    if (norm == "pnorm100")
        p = 100;
    end
    return    
end
