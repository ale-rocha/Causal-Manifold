% arocha@inaoep
% Este script verifica la forma de las variaciones de la función de
% distancia

clear variables;

opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.saveFolder = '.';
opts.width      = 8;
opts.height     = 6;
opts.fontType   = 'Times';
opts.fontSize   = 9;


%% CASO I : Variando la fase y fijando frecuencia y tiempo ---------------------------------------
%%  ----------------------------------------------------------------------------------------------
%% Storage cubinder events
event_phase = [];
event_frequency = [];
event_time = [];
event_id = [];
temp = [];
ids = 0;


%% Params to generate
sampling_rate = 100;
seconds= 1; % FIJA
freq = 5; % FIJA
min_phase = -pi;  max_phase = pi;  delta_phase =pi/8;


%% Simulation events
disp(" [ 1 ] Preparing series and events ..." )
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
end

%%Computing distances
senosoidal_matrix_distances = Compute_matrix_distances (event_phase,event_frequency,event_time);
projection = cmdscale(abs(senosoidal_matrix_distances),3);
options.method = 'rre';
options.dim = 3;

X = projection(:,1);
Y = projection(:,2);
Z = projection(:,3);

%Guardando la proyeccion CDM scale en el dafataframe
dataframe_distances = zeros(3,size(X,1));
dataframe_distances(1,:) = X ;
dataframe_distances(2,:) = Y ;
dataframe_distances(3,:) = Z ;
dataframe_distances = transpose(dataframe_distances);
csvwrite('Outputs/Dataframes/dataframe_test_distances_phase_cdmscale.csv',dataframe_distances)

%Guardando la funcion distancia en dafataframe
dataframe_distances = zeros(1,size(X,1));
dataframe_distances(1,:) = senosoidal_matrix_distances(1,:) ;
dataframe_distances = transpose(dataframe_distances);
csvwrite('Outputs/Dataframes/dataframe_test_distances_function_cdmscale.csv',dataframe_distances)


%% CASO II : Variando la frecuencia y fijando frecuencia y tiempo ---------------------------------------
%%  -----------------------------------------------------------------------------------------------------
%% Storage cubinder events


event_phase = [];
event_frequency = [];
event_time = [];
event_id = [];
temp = [];
ids = 0;


%% Params to generate
sampling_rate = 100;
seconds= 1; % FIJA
phase = pi; % FIJA
min_freq = 0;  max_freq = 50;  delta_freq = 1;


%% Simulation events
disp(" [ 2 ] Preparing series and events ..." )
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

%%Computing distances
senosoidal_matrix_distances = Compute_matrix_distances (event_phase,event_frequency,event_time);
projection = cmdscale(abs(senosoidal_matrix_distances),1);
options.method = 'rre';
options.dim = 1;
disp(size(projection));
X = projection(:,1);
Y = projection(:,1);

%Guardando la proyeccion CDM scale en el dafataframe
dataframe_distances = zeros(2,size(X,1));
dataframe_distances(1,:) = X ;
dataframe_distances(2,:) = Y ;
dataframe_distances = transpose(dataframe_distances);
csvwrite('Outputs/Dataframes/dataframe_test_distances_frequency_cdmscale.csv',dataframe_distances)

%Guardando la funcion distancia en dafataframe
dataframe_distances = zeros(1,size(senosoidal_matrix_distances,1));
dataframe_distances(1,:) = senosoidal_matrix_distances(1,:) ;
dataframe_distances = transpose(dataframe_distances);
csvwrite('Outputs/Dataframes/dataframe_test_distances_function_freq.csv',dataframe_distances)
disp("Case II DONE!")


%% CASO III : Variando el tiempo y fijando frecuencia y phase ---------------------------------------
%%  ------------------------------------------------------------------------------------------------
%% Storage cubinder events
event_phase = [];
event_frequency = [];
event_time = [];
event_id = [];
temp = [];
ids = 0;


%% Params to generate
sampling_rate = 100;
seconds= 50; % FIJA
phase = pi; % FIJA
freq = 10;


%% Simulation events
disp(" [ 2 ] Preparing series and events ..." )

[x,y] = wave(freq,phase,seconds,sampling_rate);
% Object creation 
[S_phase,S_freq,S_time] = STFT_Projection(y, sampling_rate);
%Storage
event_phase = [event_phase,S_phase];
event_frequency = [event_frequency,S_freq];
event_time = [event_time,S_time];  
event_id = [event_id,ids];


%%Computing distances
senosoidal_matrix_distances = Compute_matrix_distances (event_phase,event_frequency,event_time);
projection = cmdscale(abs(senosoidal_matrix_distances),1);
options.method = 'rre';
options.dim = 1;
disp(size(projection));
X = projection(:,1);
Y = projection(:,1);

%Guardando la proyeccion CDM scale en el dafataframe
dataframe_distances = zeros(2,size(X,1));
dataframe_distances(1,:) = X ;
dataframe_distances(2,:) = Y ;
dataframe_distances = transpose(dataframe_distances);
csvwrite('Outputs/Dataframes/dataframe_test_distances_time_cdmscale.csv',dataframe_distances)

%Guardando la funcion distancia en dafataframe
dataframe_distances = zeros(1,size(senosoidal_matrix_distances,1));
dataframe_distances(1,:) = senosoidal_matrix_distances(1,:) ;
dataframe_distances = transpose(dataframe_distances);
csvwrite('Outputs/Dataframes/dataframe_test_distances_function_time.csv',dataframe_distances)
disp("Case III DONE!")

%% Auxiliares

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


function [total_diff] = parDistancesCubinder(S1_phase,S1_freq,S1_time, S2_phase,S2_freq,S2_time)
   %Compute distances
 
           if ((abs(S1_phase -S2_phase))<=pi)
                  phase_diff = abs(power(((S1_phase)-(S2_phase)),1));
           else
                  phase_diff = abs(power((2*pi)-abs((S1_phase)-(S2_phase)),1));
           end
           %phase_diff =power(abs(S1_phase-S2_phase),2);
           freq_diff = power(abs(S1_freq - S2_freq),1);
           time_diff = power(abs(S1_time - S2_time),1);
           total_diff = power(abs(phase_diff) + abs(freq_diff),1) - abs(time_diff);
end
