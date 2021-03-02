%Call to data simulation generator
%
%   --------------------------
%   --------------------------
%              time


%Crear objecto nube de puntos
cloud = Cloud;
cloud.Id = 1;

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
        
        %Add to cloud
        cloud.Points = [cloud.Points,point];
        
        %Iterate id
        ids = ids + 1;
    end
end



%Calculate distances
%
%
%
