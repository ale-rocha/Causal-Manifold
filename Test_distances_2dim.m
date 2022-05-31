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


%% CASO I : VARIANDO FASE Y TIEMPO ---------------------------------------
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
seconds=20; % FIJA
freq = 1; % FIJA
min_phase = -pi;  max_phase = pi;  delta_phase = pi/2;
min_freq = 1;  max_freq =2;  delta_freq = 1;

%% Simulation events
disp(" [ 1 ] Preparing series and events ..." )
%for freq = min_freq:delta_freq:max_freq
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
%end

%%Computing distances
senosoidal_matrix_distances = Compute_matrix_distances (event_phase,event_frequency,event_time);
csvwrite('Outputs/Dataframes/senosoidal_matrix_distances_PHASE-TIME.csv',senosoidal_matrix_distances)



%% CASO II : VARIANDO FRECUENCIA Y TIEMPO ---------------------------------------
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
seconds=30; % FIJA
freq = 1; % FIJA
phase=pi/2;
min_phase = -pi;  max_phase = pi;  delta_phase = pi/20;
min_freq = 1;  max_freq =1;  delta_freq = 1;

%% Simulation events
disp(" [ 1 ] Preparing series and events ..." )
for freq = min_freq:delta_freq:max_freq
    %for phase = min_phase:delta_phase:max_phase
        ids = ids +1;
        [x,y] = wave(freq,phase,seconds,sampling_rate);
        % Object creation 
        [S_phase,S_freq,S_time] = STFT_Projection(y, sampling_rate);
        %Storage
        event_phase = [event_phase,S_phase];
        event_frequency = [event_frequency,S_freq];
        event_time = [event_time,S_time];  
        event_id = [event_id,ids];
    %end
end

%%Computing distances
senosoidal_matrix_distances = Compute_matrix_distances (event_phase,event_frequency,event_time);
projection = cmdscale(abs(senosoidal_matrix_distances),2);
options.method = 'rre';
options.dim = 2;

X = projection(:,1);
%Y = projection(:,2);
%Z = projection(:,3);

figure;
scatter(X,X,60,"filled")
xlabel('Distances time')
ylabel('Distances phase')
shg;

csvwrite('Outputs/Dataframes/senosoidal_matrix_distances_FREQ-TIME.csv',senosoidal_matrix_distances)

%% Auxiliares

%% CASO II : VARIANDO FRECUENCIA Y TIEMPO ---------------------------------------
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
seconds=1; % FIJA
freq = 1; % FIJA
min_phase = -pi;  max_phase = pi;  delta_phase = pi/16;
min_freq = 1;  max_freq =20;  delta_freq = 1;

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
    end
end

%%Computing distances
senosoidal_matrix_distances = Compute_matrix_distances (event_phase,event_frequency,event_time);
csvwrite('Outputs/Dataframes/senosoidal_matrix_distances_FREQ-PHASE.csv',senosoidal_matrix_distances)


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
           
           freq_diff = power(abs(S1_freq - S2_freq),1);
           time_diff = power(abs(S1_time - S2_time),1);
           total_diff = phase_diff + freq_diff - time_diff;
end
