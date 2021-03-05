%Call to data simulation generator
%
%   --------------------------
%   --------------------------
%              time


%Crear objecto nube de puntos
cloud = Cloud;
cloud.Id = 1;

temp = [];
ids = 0;
for phase = 1:3
    for freq = 1:3
        wave = sea_waves(freq,phase);   
       
        % Object creation
        point = Point;
        point.Id = ids;
        point.TimeSerie = wave;
        point.Frequency = freq;
        point.Phase = phase;
        
        %store
        temp = [temp,point];
        
        %Iterate id
        ids = ids + 1;
    end  
end

cloud.Points = temp;

%Calculate matrix distances
distances_catalogue = ["pnorm1","pnorm2","pnorm5","pnorm100"];
matrix_distances = ManagerDistances(cloud,distances_catalogue);

%mypca();
MyCylinder();
MyCone();