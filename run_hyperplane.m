%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%::::::::::::::::::::::::::: H Y P E R P L A N E :::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% arocha - Instituto Nacional de Astrofísica Optica y Electrónica - 2021
% Info:
% This is the main call to basic (sinosoidals) cubiner/hyperplane example.

clear;

% Info about instrument ---------------------
instrument = Instruments;
sampling_rate = instrument.samplingRate;              %Sampling rate instrument

% Info about observatio ---------------------
duration = 5;                                         %Time (seconds)          

% Info to series generator ranges------------
min_frequency=1; max_frequency=9; delta_frequency=1;  %Ranges frequency [min,max]
min_phase=0.1; max_phase=2*pi; delta_phase=pi/4;        %Ranges phase [min,max]


% Generando series temporales ---------------
% -------------------------------------------

phases_events = [];
frequencies_events = [];
times_events = [];
                                       
for phase = min_phase:delta_phase:max_phase                % Iterando en las fases
    for freq = min_frequency:delta_frequency:max_frequency % Iterando en las frecuencias
        serie = wave(freq,phase,duration,sampling_rate);
        %plot_serie(serie,sampling_rate);                   % Plot the serie
        
        %Calculando la STFT *****************
        win = hamming(sampling_rate,'periodic');
        [spectre_stft,frequencies_stft,time_stft]=stft(serie,seconds(1/sampling_rate),'Window',win,'OverlapLength',0);

        %Creando los eventos del manifold***
        %Iterando en cada segundo de la tranformada de fourier tt.
        for seg = 1:length(time_stft)
             disp(size(frequencies_stft));
             [max_phase,max_freq] = get_max_pf(frequencies_stft,spectre_stft,seg,true,15,true);
             phases_events = [phases_events,(phase/(freq*2*pi))]; %/(freq*2*pi)
             frequencies_events = [frequencies_events,freq];
             times_events = [times_events,seg];        
        end
        
        
    end  
    
end

distancias_matrix = [];
%Calculando distancias
for p1 = 1:length(times_events)
    for p2 = 1:length(times_events)
          diff_phase = power(phases_events(p1)-phases_events(p2),2);
          diff_freq = power(frequencies_events(p1)-frequencies_events(p2),2);
          diff_time = power(times_events(p1) - times_events(p2),2);
          distance = diff_phase + diff_freq - diff_time;
          distancias_matrix = [distancias_matrix,distance ];
          
    end
end

distancias_matrix = reshape(distancias_matrix,[length(times_events),length(times_events)]);
distancias_matrix = (distancias_matrix + (abs(min(min(distancias_matrix)))+0)) - ((abs(min(min(distancias_matrix)))+0)*eye(length(times_events))) ;
disp(distancias_matrix);

projection = cmdscale(distancias_matrix,3);

X = projection(:,1);
Y = projection(:,2);
Z = projection(:,3);

figure;
scatter3(times_events,phases_events,frequencies_events,'filled');



figure;
c = linspace(1,50,length(X));
%scatter(X,Y,60,c,"filled")
scatter3(X,Y,Z)
xlabel('Distances time')
ylabel('Distances phase')
zlabel('Distances freq')
shg;



shp = alphaShape(X,Y,Z,1);
plot(shp)
shg;












  