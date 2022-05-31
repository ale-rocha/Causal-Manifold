% arocha@inaoep
% Este script ejecuta el cubindro con seniales elementales.

clear variables;

opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.saveFolder = '.';
opts.width      = 8;
opts.height     = 6;
opts.fontType   = 'Times';
opts.fontSize   = 9;

%% Storage cubinder events
event_phase = [];
event_frequency = [];
event_time = [];
event_id = [];
temp = [];
ids = 0;


%% Params to generate
sampling_rate = 100;
seconds= 60; 
min_freq = 1;  max_freq =20;  delta_freq =1;
min_phase = -pi+0.1;  max_phase = pi-0.1;  delta_phase = .1;

%% Generate labels
disp(" [ 0 ] Generating labels ..." )
[labels,id_s] = getLabels(min_freq, max_freq, delta_freq,min_phase,max_phase,delta_phase,seconds);

%% Simulation events
disp(" [ 1 ] Preparing series and events ..." )
for phase = min_phase:delta_phase:max_phase
    for freq = min_freq:delta_freq:max_freq
        ids = ids +1;
        [x,y] = wave(freq,phase,seconds,sampling_rate);
        % Object creation 
        [S_phase,S_freq,S_time] = STFT_Projection(y, sampling_rate);
        %Storage
        event_phase = [event_phase,S_phase];
        event_frequency = [event_frequency,S_freq];
        event_time = [event_time,S_time];  
        event_id = [event_id,ids];
    end
end

%% Guardando los eventos en el dataframe para la visualizacion
% dataframe(1,:) : event_id
% dataframe(2,:) : senx
% dataframe(3,:) : cosx
% dataframe(4,:) : event_phase
% dataframe(5,:) : event_frequency
% dataframe(6,:) : event_ftime

disp(" [ 2 ] Calculando las distancias..." )
%% Visualizando el cubindro
senx = sin(event_phase);
cosx = cos(event_phase);
event_phasek = senx + cosx;

figure; hold on;
%Para visualizar las flechas
U=zeros(size(event_frequency));        U(:) = 0;
V=zeros(size(event_frequency));        V(:) = 0.5;
W=zeros(size(event_frequency));        W(:) = 0;
q=quiver3(event_frequency,event_time,event_phasek,U,V,W,'Color','[0.8 0.8 1]','Marker','.');
q.LineWidth = 1;
q.ShowArrowHead = 'on';
scatter3(event_frequency,event_time,event_phasek,20,event_frequency,'filled')
xlabel('frecuencia');
ylabel('tiempo');
zlabel('fase');
hold off;
shg;

%% Proyección simple - tiempo y fase
figure; hold on;
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
U=zeros(size(event_frequency));        U(:) = 0;
V=zeros(size(event_frequency));        V(:) = 0;
W=zeros(size(event_frequency));        W(:) = 0.5;
q=quiver3(senx,cosx,event_time,U,V,W,'Color','[0.8 0.8 1]','Marker','.');
q.LineWidth = 1;
q.ShowArrowHead = 'on';
scatter3(senx,cosx,event_time,20,cosx,'filled')
shp = alphaShape(senx(:),cosx(:),event_time(:),1.5);
plot(shp,'FaceColor','green','FaceAlpha',0.1,'EdgeAlpha', 0.1,'LineWidth', 0.1);
title ("Cubinder, proyection (phase and time)")
axis tight;
xlabel('Sin(phase)');
ylabel('Cos(phase)');
zlabel('time');
hold off;
print([opts.saveFolder 'my_figure'], '-dpng', '-r600')
shg;

pivot_event.phase =  0.5;
pivot_event.frequency = 0.5;
pivot_event.time = 0.5;
causal_cone = [];

%Normalizar todo --------------------------------
event_phase = (event_phase - min(event_phase)) / ( max(event_phase) - min(event_phase) );
event_frequency = (event_frequency - min(event_frequency)) / ( max(event_frequency) - min(event_frequency) );
event_time = (event_time - min(event_time)) / ( max(event_time) - min(event_time) );
pivot_event.phasen = (pivot_event.phase - min(event_phase)) / ( max(event_phase) - min(event_phase) );
pivot_event.frequencyn = (pivot_event.frequency - min(event_frequency)) / ( max(event_frequency) - min(event_frequency) );
pivot_event.timen = (pivot_event.time - min(event_time)) / ( max(event_time) - min(event_time) );

%disp(pivot_event.phasen)
%disp(pivot_event.frequencyn)
%disp(pivot_event.timen)

%disp("348y28349827394709234972837498723987482734")

for pindex = 1:size(event_phase,2)
            distancea = parDistancesCubinder(event_phase(pindex),event_frequency(pindex),event_time(pindex),pivot_event.phase,pivot_event.frequency,pivot_event.time);
            
            %if distancea<0
            %    causal_cone = [causal_cone,1];
            %elseif distancea == 0
            %    causal_cone = [causal_cone,2];
            %elseif distancea == 0 && (event_phase(pindex) ==pivot_event.phase) && (event_frequency(pindex) ==pivot_event.frequency) && (event_time(pindex) ==pivot_event.time )
            %     causal_cone = [causal_cone,0];
            %     disp("====> equals");
            %elseif distancea > 0 
            %    causal_cone = [causal_cone,3];
            %end
            %%%
            causal_cone = [causal_cone,distancea];
            %disp(distancea);
end



dataframe = zeros(7,size(event_phase,2));
dataframe(1,:) = id_s ;
dataframe(2,:) = senx ;
dataframe(3,:) = cosx ;
dataframe(4,:) = event_phase ;
dataframe(5,:) = event_frequency ;
dataframe(6,:) = event_time ;
dataframe(7,:) = causal_cone ;
dataframe = transpose(dataframe);
csvwrite('Outputs/Dataframes/dataframe_events_cubinder.csv',dataframe)
disp(" [ 3 ] .............." )
jbj
%% Proyecciones 4D -> 3D
%Funciona, aunque si no es animado no se aprecia bien
%[pro_x, pro_y, pro_z] = projection4Dto3D(cosx,senx,event_frequency, event_time);
%figure;
%scatter3(pro_x, pro_y, pro_z,20,pro_z,'filled')
%shg;

%% Computing distances
disp(" [ 2 ] Computing distances ..." )
senosoidal_matrix_distances = Compute_matrix_distances (event_phase,event_frequency,event_time);
csvwrite('Outputs/Dataframes/senosoidal_matrix_distances.csv',senosoidal_matrix_distances)
cdata = senosoidal_matrix_distances;
xvalues = labels;
yvalues =  labels;
figure
h = heatmap(xvalues,yvalues,cdata);
h.Title = 'My Heatmap Title';
h.XLabel = 'My Label';
h.YLabel = 'My Label';
h.GridVisible = 'off';
h.Colormap = parula;
shg;


%% Proyección orthogonal
% TODO : Check that de ajustment to cmd is correct
%Debido a que hay distancias negativas, es necesario
%senosoidal_matrix_distances = senosoidal_matrix_distances + min(senosoidal_matrix_distances);
senosoidal_matrix_distances = (senosoidal_matrix_distances + (abs(min(min(senosoidal_matrix_distances))))+0) - ((abs(min(min(senosoidal_matrix_distances)))+0)*eye(length(event_phase))) ;
csvwrite('Outputs/Dataframes/senosoidal_matrix_distances_corrected.csv',senosoidal_matrix_distances)

figure
h = heatmap(xvalues,yvalues,senosoidal_matrix_distances);
h.Title = 'My Heatmap Title';
h.XLabel = 'My Label';
h.YLabel = 'My Label';
h.GridVisible = 'off';
h.Colormap = parula;
shg;



projection = cmdscale(abs(senosoidal_matrix_distances),4);
options.method = 'rre';
options.dim = 4;




X = projection(:,1);
Y = projection(:,2);
Z = projection(:,3);
W = projection(:,4);

figure;
c = linspace(1,50,length(X));
scatter3(X,Y,Z,60,c,"filled")
xlabel('Distances time')
ylabel('Distances phase')

figure;
c = linspace(1,50,length(X));
scatter3(Y,Z,W,60,c,"filled")
xlabel('Distances time')
ylabel('Distances phase')


dataframe_distances = zeros(4,size(X,1));
dataframe_distances(1,:) = X ;
dataframe_distances(2,:) = Y ;
dataframe_distances(3,:) = Z ;
dataframe_distances(4,:) = W ;
dataframe_distances = transpose(dataframe_distances);
csvwrite('Outputs/Dataframes/dataframe_distances_cdmscale.csv',dataframe_distances)

disp("Ok");


%% --------------------------------------------------------------
%% Haciendo pruebas de portadoras -------------------------------
% Experimento 1 -------------------------------------------------
sampling_rate = 100;
seconds= 60; 
min_freq = 1;  max_freq =6;  delta_freq = 1;
min_phase = -pi+0.1;  max_phase = pi-0.1;  delta_phase = .2;


for phase1 = min_phase:delta_phase:max_phase
    for freq1 = min_freq:delta_freq:max_freq
        for phase2 = min_phase:delta_phase:max_phase
             for freq2 = min_freq:delta_freq:max_freq
                  % WAVE 1
                  [x1,y1] = wave(freq1,phase1,seconds,sampling_rate);
                  % WAVE 1
                  [x2,y2] = wave(freq2,phase2,seconds,sampling_rate);
                  % STFT
                  [S_phase,S_freq,S_time] = STFT_Projection(y, sampling_rate);
                  %Storage
             end
         end
    end
end


function [temp_matrix_distances] = Compute_matrix_distances(phases, freqs, time)
   %itera sobre las caracteristicas de los eventos (fases, frecuencias y tiempos)
   % para obtener una matriz cuadrada
   temp_matrix_distances = zeros(length(phases),length(phases));
   for e1 = 1:length(phases)
       for e2 = 1:length(phases)
           temp_matrix_distances(e1,e2) = parDistancesCubinder(phases(e1),freqs(e1),time(e1),phases(e2),freqs(e2),time(e2));
       end
   end
end

function [labels,id_s] = getLabels(min_freq, max_freq, delta_freq,min_phase,max_phase,delta_phase,seconds)
   labels= []; 
   id_s = [];
   id = 0;
    for phase = min_phase:delta_phase:max_phase
        for freq = min_freq:delta_freq:max_freq
            for sec = 1:seconds
                   id = id +1;
                   namephase = string(phase+pi);
                   namefrequency = string(freq);
                   nametime = string(sec);
                   name = strcat( {'p:'},namephase, {', f:'},namefrequency, {', t:'},nametime);
                   labels = [labels,name];
                   id_s = [id_s,id];
            end
        end
    end
end


function [total_diff] = parDistancesCubinder(S1_phase,S1_freq,S1_time, S2_phase,S2_freq,S2_time)
   %Compute distances
 
           if ((abs(S1_phase -S2_phase))<=pi)
                  phase_diff = abs(power(((S1_phase)-(S2_phase)),1));
           else
                  phase_diff = abs(power((2*pi)-abs((S1_phase)-(S2_phase)),1));
           end
           freq_diff = power(S1_freq - S2_freq,1);
           time_diff = power(S1_time - S2_time,1);
           total_diff = abs(phase_diff) + abs(freq_diff)- abs(time_diff);
end


function [projected3d_x,projected3d_y,projected3d_z] = projection4Dto3D(cos_phase,sin_phase,freq_event, time_event)
   projected3d_x = [];
   projected3d_y = [];
   projected3d_z = [];
   angle = 3*(pi / 2);

  for i = 1:length(sin_phase)
      v = [cos_phase(i);sin_phase(i);freq_event(i);time_event(i)];

      rotationXY = [
      [cos(angle), -sin(angle), 0, 0],
      [sin(angle), cos(angle), 0, 0],
      [0, 0, 1, 0],
      [0, 0, 0, 1],
       ];

    rotationZW = [
      [1, 0, 0, 0],
      [0, 1, 0, 0],
      [0, 0, cos(angle), -sin(angle)],
      [0, 0, sin(angle), cos(angle)]
    ];

    rotated = rotationXY*v;
    rotated = rotationZW*rotated;


    projection = [
      [1/2, 0, 0, 0],
      [0, 1/2, 0, 0],
      [0, 0, 1/2, 0],
    ];

    projected = projection*rotated;
   projected3d_x = [projected3d_x, projected(1,:)];
   projected3d_y = [projected3d_y,projected(2,:)];
   projected3d_z = [projected3d_z,projected(3,:)];

  
  end
end