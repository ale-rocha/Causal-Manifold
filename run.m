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


for phase = 0.5:0.5:2*pi
    for freq = 1:5:20
        wave = sea_waves(freq,phase); 
        
        % Object creation 
        point = Point;
        point.Id = ids;
        point.TimeSerie = wave;
        point.Frequency = freq;
        point.Phase = phase;
        
        
        %Manifod causal
        causalFeatures  = CausalFeatures;
        %figure;
        [ss,f,t]=stft(wave,freq);
        %stft(X,1000);
        %shg;
        causalFeatures.FourierTransform = ss;
        causalFeatures.Frequencies = f;
        causalFeatures.Times = t;
        
        %Calcular el promedio de las fasesy frecuencias de cada ventana
        promedio_freq = [];
        promedio_phases = [];
        
        
        for p = 1:length(t)
                control = ss(:,p);
                [indice, valormax] = max(abs(control));
                frecuencia_correcta = f(valormax);
                disp("--------tiempo");
                disp(p);
                disp("-----------valor max ");
                disp(int16(abs(frecuencia_correcta)-2))
                frecuenciamax = int16(abs(frecuencia_correcta)-2);
                disp("------------- fase")
                disp(max(angle(ss(:,p))))
                fasemaxica = max(angle(ss(:,p)));
                
                promedio_freq  = [promedio_freq,frecuenciamax];
                promedio_phases = [promedio_phases, phase];
        end

        causalFeatures.MeanFrequencies = promedio_freq;
        causalFeatures.MeanPhases = promedio_phases;
        
        point.CausalFeatures = causalFeatures;
        
        %store
        temp = [temp,point];
        
        %Iterate id
        ids = ids + 1;
    end  
end

cloud.Points = temp;

%Plotting Manifold ----------------------------------------------------
%disp(cloud)
disp("00000000000000000000000000000000000")
MyCylinder(cloud);
%ConeTest()
%CausalCylinder(cloud);
%MyCone(cloud);
%%%%%  MyCylinder(cloud);

%Calculate matrix distances -------------------------------------------
distances_catalogue = ["pnorm1","pnorm2","pnorm5","cosine","correlation","geodesical"];
cloud.Matrix_Distances = ManagerDistances(cloud,distances_catalogue);
%Computing projections%------------------------------------------------
cloud.Projections = ManagerProjections(cloud,distances_catalogue);
%Plotting projections -------------------------------------------------
ScatterProjection(cloud,distances_catalogue);


%Calcular tranformadas de fourier en tiempo corto


