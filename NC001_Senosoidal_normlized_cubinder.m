% arocha@inaoep
% Este script ejecuta el cubindro normalizado con seniales elementales.
% Clave del script NC001 : Normalized cubinder
key_script = "NC001";


%% Primer experimento (normalized senosoidal cubinder)
% Para visualiza el cubindro normalizado un primer experimento
% Señales senosoidales completas


clear variables;
%% Storage cubinder events
event_phase = [];
event_frequency = [];
event_time = [];
event_id = [];
temp = [];
ids = 0;

%% Params to generate events
sampling_rate = 100;
seconds= 6;  
min_freq = 1;  max_freq =2;  delta_freq = 1;   
min_phase = -pi+0.001;  max_phase = pi;  delta_phase = pi/4;  % Phase is naturally in the range (0,1)
freq = 0.2;

%labels
labels= [];
id_s = [];
id = 1;

%% Simulation events
disp(" [ 1 ] Preparing series and events ..." )
for freq = min_freq:delta_freq:max_freq
    for phase = min_phase:delta_phase:max_phase
        ids = ids +1;
        [x,y] = wave(freq,phase,seconds,sampling_rate);
        % Object creation 
        [S_phase,S_freq,S_time] = STFT_Projection(y, sampling_rate);
        %Storage
        event_phase = [event_phase,S_phase];
        event_frequency = [event_frequency,S_freq];
        event_time = [event_time,S_time];  
        event_id = [event_id,ids];
        
         %Saving labels ------------------------------------------
        for l = 1:length(S_time)
             namefrequency = string(S_freq(l));
             nametime = string(S_time(l));
             namephase = string(S_phase(l)-pi);
             truephase = string(phase);
             name = strcat( {'p:'},namephase, {', f:'},namefrequency, {', t:'},nametime);
             disp(name);
             labels = [labels,name];
             id_s = [id_s,id];
             id = id+1;
        end
    end
end

%% Visualizando el cubindro
senx = sin(event_phase);
cosx = cos(event_phase);

%% Normalizando tiempo y la frecuencia de 0 a 1
event_time =  (event_time - min(event_time)) / ( max(event_time) - min(event_time) );
event_frequency = (event_frequency - min(event_frequency)) / ( max(event_frequency) - min(event_frequency) );
event_phasek = senx + cosx;

%% Guardando el cumbindro normalizado
dataframe = zeros(6,size(event_phase,2));
dataframe(1,:) = id_s ;
dataframe(2,:) = senx ;
dataframe(3,:) = cosx ;
dataframe(4,:) = event_phase ;
dataframe(5,:) = event_frequency ;
dataframe(6,:) = event_time ;
dataframe = transpose(dataframe);
csvwrite('Outputs/Dataframes/NC001_events_cubinder.csv',dataframe)


%% Computing distances and save
disp(" [ 2 ] Computing distances ..." )
senosoidal_matrix_distances = Compute_matrix_distances (event_phase,event_frequency,event_time);
csvwrite('Outputs/Dataframes/NC001_senosoidal_matrix_distances.csv',senosoidal_matrix_distances)

figure
h = heatmap(labels,labels,senosoidal_matrix_distances);
h.Title = 'NC001 - senosoidal_matrix_distances ';
h.XLabel = 'Event';
h.YLabel = 'Event';
h.GridVisible = 'off';
h.Colormap = parula;
shg;


%% Auxiliar functions


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
   for freq = min_freq:delta_freq:max_freq
        for phase = min_phase:delta_phase:max_phase
            for sec = 1:seconds
                   id = id +1;
                   freq_n =  (freq - min_freq) / ( max_freq- min_freq ); %Normalizando
                   sec_n = (sec - 1) / ( seconds- 1 );                   %Normalizando
                   namephase = string(phase+pi);
                   namefrequency = string(freq_n);
                   nametime = string(sec_n);
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
           freq_diff = abs(S1_freq - S2_freq);
           time_diff = S1_time - S2_time;
           total_diff = phase_diff + freq_diff - abs(time_diff);
end

