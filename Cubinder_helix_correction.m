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
event_phase_helix = [];
event_frequency = [];
event_time = [];
event_id = [];
temp = [];
ids = 0;


%% Params to generate
sampling_rate = 100;
seconds= 30; 
min_freq = 1;  max_freq =10;  delta_freq = 1;
min_phase = -pi+0.1;  max_phase = pi-0.1;  delta_phase = pi/16;

labels = [];
id_s = [];
id = 0;

freq = 2;

%% Simulation events
disp(" [ 1 ] Preparing series and events ..." )
nphases = 0;
phases_identification = [];
for phase = min_phase:delta_phase:max_phase
    nphases = nphases+ 1;
    phases_identification = [phases_identification,phase];
    %for freq = min_freq:delta_freq:max_freq
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
             labels = [labels,name];
             id_s = [id_s,id];
             id = id+1;
        end
    %end
end

%% Corrigiendo la fase agregando dimension extra
event_phase_helix = makeHelixCorrection(seconds,nphases,phases_identification,event_phase,event_time);
senx = sin(event_phase);
cosx = cos(event_phase);

%% Guardando el cumbindro normalizado
dataframe = zeros(7,size(event_phase,2));
dataframe(1,:) = id_s ;
dataframe(2,:) = senx ;
dataframe(3,:) = cosx ;
dataframe(4,:) = event_phase ;
dataframe(5,:) = event_frequency ;
dataframe(6,:) = event_time ;
dataframe(7,:) = event_phase_helix ;
dataframe = transpose(dataframe);
csvwrite('Outputs/Dataframes/HC001_events_helix_cubinder.csv',dataframe)



figure;
c = linspace(1,50,length(event_phase_helix));
scatter3(cos(event_phase),sin(event_phase),event_phase_helix,60,c,"filled")

%% Computing distances
disp(" [ 2 ] Computing distances ..." )
senosoidal_matrix_distances = Compute_matrix_distances (event_phase,event_frequency,event_time,event_phase_helix);
csvwrite('Outputs/Dataframes/HC001_helix_matrix_distances.csv',senosoidal_matrix_distances)
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





function [temp_matrix_distances] = Compute_matrix_distances(phases, freqs, time,helixdistance)
   %itera sobre las caracteristicas de los eventos (fases, frecuencias y tiempos)
   % para obtener una matriz cuadrada
   temp_matrix_distances = zeros(length(phases),length(phases));
   for e1 = 1:length(phases)
       for e2 = 1:length(phases)
           temp_matrix_distances(e1,e2) = parDistancesCubinder(phases(e1),freqs(e1),time(e1),phases(e2),freqs(e2),time(e2),helixdistance(e1),helixdistance(e2));
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


function [h_dimension] = makeHelixCorrection(duration,nphases, phases_identification,event_phase,event_time)
    % Step 3: Create a new h dimension
    correction = [];
    correction = [correction,0];
    for p = 1:nphases%for each phase
        correction = [correction,(duration*0.5)*-p];
    end
    correction = correction;
    
    %disp(correction);
    phases_identification = phases_identification + pi;
    % Creating new dimension
    h_dimension = [];
    for p = 1:length(event_phase)
        for idp = 1:length(phases_identification)
            if round(event_phase(p),1) == round(phases_identification(idp),1)
                h_dimension = [h_dimension,correction(idp)]; % +event_time(p)
            end
        end
    end
    
end



function [total_diff] = parDistancesCubinder(S1_phase,S1_freq,S1_time, S2_phase,S2_freq,S2_time,S1_helix,S2_helix)
   %Compute distances
 
           if ((abs(S1_phase -S2_phase))<=pi)
                  phase_diff = abs(S1_phase-S2_phase);
           else
                  phase_diff = (2*pi)-abs(S1_phase-S2_phase);
           end
           freq_diff = power(S1_freq - S2_freq,1);
           time_diff = S1_time - S2_time;
           total_diff = abs(phase_diff) + abs(freq_diff) - (abs(time_diff) - abs(S1_helix - S2_helix ))/10 ;


end