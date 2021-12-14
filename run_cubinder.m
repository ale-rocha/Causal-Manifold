%Call to data simulation generator
%
%   --------------------------
%   --------------------------
%              time

clear variables;



%Crear objecto nube de puntos

% phase, frequency, time

point_phase = [];
point_frequency = [];
point_time = [];


cloud = Cloud;
cloud.Id = 1;

temp = [];
ids = 0;

sampling_rate = 1/1000;

numberseries = 0;

for phase = pi/7:pi/7:2*pi
    disp("Number series --------");
    disp(numberseries);
    numberseries = numberseries + 1;
    for freq = 1:1:6
  
        wave = sea_waves(freq,phase); 
        
        % Object creation 
        point = Point;
        point.Id = ids;
        point.TimeSerie = wave;
        point.Frequency = freq;
        point.Phase = phase;
        
        %Manifod causal
        causalFeatures  = CausalFeatures;
        
        %Computing STFT. For each second, is calculated the FT
        %using a hamming window with 0 overlap 
        %TODO: Check in real data if this approximation (hammming window)
        %is useful.
        win = hamming(1000,'periodic');
        [spectre_stft,frequencies_stft,time_stft]=stft(wave,seconds(1/1000),'Window',win,'OverlapLength',0);
        %Now, it is necesary save the max frequency and phase of each time
        %segment.
        
        store_max_freq = [];
        store_max_phases = [];
        store_time = [];
        
        disp("Numero de segundos");
        disp(time_stft);
        for sec = 1:length(time_stft) %For each second
            
                %Extrayendo el índice correspondiente al valor maximo de
                %energía registrada
                %Ojo. Se toma solo la parte positiva del especto, por eso
                %el: spectre_stft)/2:length(spectre_stft) -> Es la segunda
                %mitad del espectro
                [max_energy, index] = max(abs(spectre_stft(length(spectre_stft)/2:length(spectre_stft),sec)));
                %Extraer el valor de frecuencia con el indice (index)
                catologue_frequencies = frequencies_stft(length(frequencies_stft)/2:length(frequencies_stft));
                maximun_frequencies = catologue_frequencies(index);  % Frequencia con mayor energia
                %Para extraer la fase.
                %Temporalmete, esto se estimara de forma harcodeada
                %Dado que es necesario tomar en cuentas las distoricones de
                %fase al momento de realizar la STFT
                % ---- Codigo para obtener la fase -----
                %stem(frequencies_stft,angle(spectre_stft(:,sec)));
                %max(angle(spectre_stft(:,sec)))
                %Display
                %disp("-tiempo");
                %disp(sec);
                %disp("-valor frequency max ");
                %disp(maximun_frequencies)
                %disp("-fase")
                %disp(phase)
                
                
                point_phase = [point_phase,phase];
                point_frequency = [point_frequency,maximun_frequencies];
                point_time = [point_time,sec];
                
                %Store
                
                store_max_freq = [store_max_freq,maximun_frequencies];
                store_max_phases = [store_max_phases,phase];
                store_time = [store_time,sec]; 
                
        end
        
        causalFeatures.FourierTransform = spectre_stft;
        causalFeatures.Frequencies = frequencies_stft;
        causalFeatures.Times = time_stft;
        %Save in point
        point.CausalFeatures = causalFeatures;
        %store
        temp = [temp,point];
        %Iterate id
        ids = ids + 1;
    end  
end

%-----------------------------------------------------------------------------
figure;
x1=cos(point_phase);
x2=sin(point_phase);
shp = alphaShape(x1(:),x2(:),point_frequency(:),10);
S = linspace(20,80,length(x1));
plot(shp,'FaceColor','blue','FaceAlpha',0.1,'EdgeAlpha', 0.1,'LineWidth', 0.1); hold on;
scatter3(x1,x2,point_frequency,1,point_frequency,'filled')
zlabel('frequency')
xlabel('phase')
ylabel('phase')
shg;
[bf, P] = boundaryFacets(shp);
stlwrite(triangulation(bf, P),'modelcubinderCUBINDER.stl') %guardando para node


figure;
x1=cos(point_phase);
x2=sin(point_phase);
shp = alphaShape(x1(:),x2(:),point_time(:),1.5);
plot(shp,'FaceColor','red','FaceAlpha',0.1,'EdgeAlpha', 0.1,'LineWidth', 0.1); hold on;
scatter3(x1,x2,point_time,1,"filled")
zlabel('time')
xlabel('phase')
ylabel('phase')

shg;
[bf, P] = boundaryFacets(shp);
stlwrite(triangulation(bf, P),'modelcubinder.stl') %guardando para node


figure;
x1=cos(point_phase);
x2=sin(point_phase);


shp = alphaShape(x1(:),point_frequency(:),point_time(:),1.5);
plot(shp,'FaceColor','green','FaceAlpha',0.1,'EdgeAlpha', 0.1,'LineWidth', 0.1); hold on;
scatter3(x1,point_frequency,point_time,1,"filled")
zlabel('time')
xlabel('phase')
ylabel('freq')

shg;
[bf, P] = boundaryFacets(shp);
%stlwrite(triangulation(bf, P),'modelcubinder.stl') %guardando para node


%-----------------------------------------------------------------------------

%Calculate causal distances
names = [];
distances_matrix = [];
for p1 = 1:length(point_time)
    namephase = string(point_phase(p1));
    namefrequency = string(point_frequency(p1));
    nametime = string(point_time(p1));
    name = strcat( {'p:'},namephase, {', f:'},namefrequency, {', t:'},nametime);

    
    names = [names,name];
  for p2 = 1:length(point_time)
      x1= cos(point_phase(p1));
      y1= sin(point_phase(p1));
      z1= point_frequency(p1);
      w1= point_time(p1);
      
      x2= cos(point_phase(p2));
      y2= sin(point_phase(p2));
      z2= point_frequency(p2);
      w2= point_time(p2);
      if (abs(point_phase(p1)-point_phase(p2))<=pi)
          phase_temp = abs(power(((point_phase(p1))-(point_phase(p2))),2));
          
      else
          %phase_temp = power((point_phase(p1)-point_phase(p2)),2);
          phase_temp = abs(power((2*pi)-abs((point_phase(p1))-(point_phase(p2))),2));
      end
      freq_temp = abs(power((point_frequency(p2)-point_frequency(p1)),2));
      time_temp = abs(power((point_time(p1)-point_time(p2)),2));
      distance = phase_temp + freq_temp  + time_temp;
      if distance >= 0
          distance = sqrt(distance);
      else
          distance = imag(sqrt(distance));
      end
      distances_matrix = [distances_matrix,distance];
      
  end
end



%Reshape to square shape distances matrix^
%distances_matrix = distances_matrix + min(distances_matrix);
distances_matrix = reshape(distances_matrix,[length(point_time),length(point_time)]);

d2 =distances_matrix;


%Debido a que hay distancias negativas, es necesario
%desplazar la matriz algunas unidades
%distances_matrix = (distances_matrix + (abs(min(min(distances_matrix))))+0) - ((abs(min(min(distances_matrix)))+0)*eye(length(point_time))) ;
%distances_matrix = power(distances_matrix,1/2);

cdata = d2;
xvalues = names;
yvalues =  names;
figure;
h = heatmap(xvalues,yvalues,real(cdata));
shg;

cdata = distances_matrix;
xvalues = names;
yvalues =  names;
figure;
h = heatmap(xvalues,yvalues,cdata);
shg;

disp("Comenzando a calcular la projection ... ");

projection = cmdscale(abs(distances_matrix),3);
options.method = 'rre';
options.dim = 3;




X = projection(:,1);
Y = projection(:,2);
Z = projection(:,3);
%W = projection(:,4);

disp(X);

figure;
c = linspace(1,50,length(X));
scatter3(X,Y,Z,60,c,"filled")
xlabel('Distances time')
ylabel('Distances phase')
%zlabel('Distances freq')
shg;

figure;
c = linspace(1,50,length(Z));
shp = alphaShape(X,Y,Z,2);
plot(shp,'FaceColor','black','FaceAlpha',0.1,'EdgeAlpha', 0.1,'LineWidth', 0.1); hold on;
S = linspace(20,80,length(X));
scatter3(X,Y,Z,S,c,"filled")
shg;
[bf, P] = boundaryFacets(shp);
stlwrite(triangulation(bf, P),'modelcubinder3dxyzA.stl') %guardando para node
xlabel('Distances frequency')
ylabel('Distances phase')
zlabel('Distances phase')

figure;
c = linspace(1,50,length(Y));
shp = alphaShape(Y,Z,W,1.5);
light('Position',[-1 0 0],'Style','local');
plot(shp,'FaceColor','red','FaceAlpha',0.1,'EdgeAlpha', 0.1,'LineWidth', 0.1); hold on;
zlabel('Distances time')
xlabel('Distances phase')
ylabel('Distances phase')
S = linspace(20,80,length(W));
scatter3(Y,Z,W,S,c,"filled")
shg;
[bf, P] = boundaryFacets(shp);
stlwrite(triangulation(bf, P),'modelcubinder3dyxw.stl') %guardando para node


figure;
c = linspace(1,50,length(Y));
shp = alphaShape(X,W,Y,2);
light('Position',[-1 0 0],'Style','local');
S = linspace(20,80,length(W));
plot(shp,'FaceColor','blue','FaceAlpha',0.1,'EdgeAlpha', 0.1,'LineWidth', 0.1); hold on;
scatter3(X,W,Y,S,c,"filled")
zlabel('Distances time')
ylabel('Distances phase')
xlabel('Distances frequency')

[bf, P] = boundaryFacets(shp);
stlwrite(triangulation(bf, P),'modelcubinder3dxyw.stl') %guardando para node
shg;





%Ejemplo paper conectivity

