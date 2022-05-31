%arocha@inaoep
% Este script ejecuta el cubindro con seniales elementales.

clear variables;

opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.saveFolder = '.';
opts.width      = 8;
opts.height     = 6;
opts.fontType   = 'Times';
opts.fontSize   = 9;



%% Params to generate datasets
params.sampling_rate = 100;
params.seconds= 30; 
params.min_freq = 1;  params.max_freq =20;  params.delta_freq = 1;
params.min_phase = -pi+0.1;  params.max_phase = pi-0.1;  params.delta_phase = pi/16;



%% Comparative phase - time
params.is_time_fixed = false;
params.is_phase_fixed = false;
params.is_freq_fixed = true;
params.freq_fixed_value = 2;
[event_phase,event_frequency,event_time,event_id] = get_sea_waves (params); %Series generator
Compute_distance_spase(event_phase, event_frequency, event_time, "PHASE-TIME");


%% Comparative frequency - time
params.is_time_fixed = false;
params.is_phase_fixed = true;
params.is_freq_fixed = false;
params.phase_fixed_value = pi;
[event_phase,event_frequency,event_time,event_id] = get_sea_waves (params);
Compute_distance_spase(event_phase, event_frequency, event_time, "FREQ-TIME");

%% Comparative frequency- phase
params.is_time_fixed = false;
params.is_phase_fixed = false;
params.is_freq_fixed = false;
params.seconds= 1; 
[event_phase,event_frequency,event_time,event_id] = get_sea_waves (params);
Compute_distance_spase(event_phase, event_frequency, event_time, "FREQ-PHASE");


%% Computing distances
%disp(" [ 2 ] Computing distances ..." )
%senosoidal_matrix_distances = Compute_distance_spase (event_phase,event_frequency,event_time);


function [event_phase,event_frequency,event_time,event_id] = get_sea_waves (params) 

    event_phase = [];
    event_frequency = [];
    event_time = [];
    event_id = [];
    temp = [];
    ids = 0;
    
    if(params.is_phase_fixed) 
         disp(" [ 1 ] Preparing series and events ..." )
         for freq = params.min_freq:params.delta_freq:params.max_freq
                  ids = ids +1;
                  [x,y] = wave(freq,params.phase_fixed_value,params.seconds,params.sampling_rate);
                  % Object creation 
                  [S_phase,S_freq,S_time] = STFT_Projection(y, params.sampling_rate);
                  %Storage
                  event_phase = [event_phase,S_phase];
                  event_frequency = [event_frequency,S_freq];
                  event_time = [event_time,S_time];  
                  event_id = [event_id,ids];
         end
         disp(" [ 1 ] ... done" )
        
    elseif(params.is_freq_fixed) 
        
         disp(" [ 1 ] Preparing series and events ..." )
         for phase = params.min_phase:params.delta_phase:params.max_phase
                  ids = ids +1;
                  [x,y] = wave(params.freq_fixed_value,phase,params.seconds,params.sampling_rate);
                  % Object creation 
                  [S_phase,S_freq,S_time] = STFT_Projection(y, params.sampling_rate);
                  %Storage
                  event_phase = [event_phase,S_phase];
                  event_frequency = [event_frequency,S_freq];
                  event_time = [event_time,S_time];  
                  event_id = [event_id,ids];
         end
          disp(" [ 1 ] ... done" )
         
    else         
         disp(" [ 1 ] Preparing series and events ..." )
         for phase = params.min_phase:params.delta_phase:params.max_phase
              for freq = params.min_freq:params.delta_freq:params.max_freq
                  ids = ids +1;
                  [x,y] = wave(freq,phase,params.seconds,params.sampling_rate);
                  % Object creation 
                  [S_phase,S_freq,S_time] = STFT_Projection(y, params.sampling_rate);
                  %Storage
                  event_phase = [event_phase,S_phase];
                  event_frequency = [event_frequency,S_freq];
                  event_time = [event_time,S_time];  
                  event_id = [event_id,ids];
              end
         end
         disp(" [ 1 ] ... done" )
    end

end



function [total_diff] = parDistancesCubinder(S1_phase,S1_freq,S1_time, S2_phase,S2_freq,S2_time)
   %Compute distances
 
           if ((abs(S1_phase -S2_phase))<=pi)
                  phase_diff = abs(S1_phase-S2_phase);
           else
                  phase_diff =(2*pi)-abs((S1_phase)-(S2_phase));
           end
           freq_diff = S1_freq - S2_freq;
           time_diff = S1_time - S2_time;
           total_diff = power(abs(phase_diff) + abs(freq_diff),1) - abs(time_diff);
end

function [temp_matrix_distances] = Compute_distance_spase(phases, freqs, time,name)
   %itera sobre las caracteristicas de los eventos (fases, frecuencias y tiempos)
   % para obtener una matriz cuadrada
   phases_increments = [];
   freqs_increments = [];
   time_increments = [];
   temp_vector_distances = [];
   e1 = 1; %Event fixed
   e1_phase = phases(1); %Event fixed
   e1_freqs = freqs(1); %Event fixed
   e1_time = time(1);   %Event fixed
       for e2 = 1:length(phases)
           phases_increments = [phases_increments, phases(e2)];
           freqs_increments = [freqs_increments, freqs(e2)];
           time_increments = [time_increments, time(e2)];
           temp_vector_distances = [temp_vector_distances, parDistancesCubinder(e1_phase,e1_freqs,e1_time,phases(e2),freqs(e2),time(e2))];
       end
       
   % Plot 
   if (name == "PHASE-TIME")
        figure;
        scatter3(phases_increments,time_increments,temp_vector_distances,8,"filled");
        xlabel("Phases increments");
        ylabel("Time increments");
        zlabel("Distance");
        colormap(jet);
        title(name);
   elseif (name == "FREQ-TIME")
        figure;
        scatter3(freqs_increments,time_increments,temp_vector_distances,8,"filled");
        xlabel("Frequency increments");
        ylabel("Time increments");
        zlabel("Distance");
        colormap(jet);
        title(name);
   elseif (name == "FREQ-PHASE")
        figure;
        scatter3(freqs_increments,phases_increments,temp_vector_distances,8,"filled");
        xlabel("Frequency increments");
        ylabel("Phases increments");
        zlabel("Distance");
        colormap(jet);
        title(name);
   end
   
end