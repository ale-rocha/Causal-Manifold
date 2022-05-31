% arocha@inaoep
% Este script ejecuta el cubindro con seniales elementales.

clear variables;

%% Get simulations -------------------------------------------------------
%% Display configurations
name_example = "Tak - unit test";   %Only a experiment name to display
verbose_plot = true;                %Plot results?
%% Model Tak params
freq = params_series();
[A,B,C]= params_theta("Tak");
[U, timestamps] = getinputs(freq, 5, 25, 2); 

%% DCM start!
%% Neurodynamics
[Z] = Neurodynamics(A,B,C,U, 1/freq);

%% Hemodynamic
P_SD = [0.5 0.5 0.5 3];
[P,Q] = Hemo(Z, U, P_SD, A,1/freq);

%% Optic
Noise = 0;
[R1,R2] = OpticMaster( P,Q,U,A,Noise); 

disp("SAlida optica");
disp(size(R1))
plot(transpose(R2));
shg;

%% Projection to cubinder -------------------------------------------------
% En las siguientes lineas, se realizará en proceso de tranformada corta
% de fourier para las señales. 
% Notas sobre el experimento: 
% [1] Se tomarán los canales que parezcan más sensibles a cada una de las regiones.
% [2] Solo se analizará una longitud de onda x region (7)
sample_rate = 10;


% Proyectando senial de la region 1
[phase_R1,freq_R1,time_R1] = STFT_Projection(R1(1,:)*10,sample_rate);
% Proyectando senial de la region 2
[phase_R2,freq_R2,time_R2] = STFT_Projection(R2(5,:)*10,sample_rate);

figure;
hold on;
plot(R1(1,:)*10)
plot(R1(5,:)*10)
hold off;
shg;

%Calculando la matriz de distancias
matrix_distances = DistancesCubinder(phase_R1,freq_R1,time_R1, phase_R2,freq_R2,time_R2);
figure;
mymap = [0 0 0
    1 0 0
];
h = heatmap(matrix_distances,'Colormap', mymap);
shg;

%% Utils projections -------------------------------------------------------------------------

function [store_max_phases, store_max_freq, store_time] = STFT_Projection(signal, sample_rate)
    % Project the signals to phase, frequency and time
    %computing signal duration
    ntimesteps = size(signal,2);
    duration = ntimesteps/sample_rate;
    %round seconds
    duration = round(duration);
    disp("Signal duration (s)");
    disp(duration);
    signal = signal(1:duration*sample_rate);
    
    store_max_freq = [];
    store_max_phases = [];
    store_time = [];
    
    %STFT
    win = hamming(sample_rate,'periodic');
    [spectre_stft,frequencies_stft,time_stft] = stft(signal,sample_rate,'Window',win,'OverlapLength',0);
    %stft(signal,sample_rate,'Window',win,'OverlapLength',0);
    %Now, it is necesary save the max frequency and phase of each second
    time_stft = round(time_stft);

    
    for sec = 1:length(time_stft) %For each second
            
                %Extrayendo el índice correspondiente al valor maximo de
                %energía registrada
                %Ojo. Se toma solo la parte positiva del especto, por eso
                %el: spectre_stft)/2:length(spectre_stft) -> Es la segunda
                %mitad del espectro
                disp("length(spectre_stft)")
                nsizefreq = size(spectre_stft,1);
                [max_energy, index] = max(abs(spectre_stft(nsizefreq/2:nsizefreq,sec)));
                %Extraer el valor de frecuencia con el indice (index)
                catologue_frequencies = frequencies_stft(nsizefreq/2:nsizefreq);
                maximun_frequencies = catologue_frequencies(index);  % Frequencia con mayor energia
                %Para extraer la fase.
                %Temporalmete, esto se estimara de forma harcodeada
                %Dado que es necesario tomar en cuentas las distoricones de
                %fase al momento de realizar la STFT
                % ---- Codigo para obtener la fase -----
                %stem(frequencies_stft,angle(spectre_stft(:,sec)));
                max_phase = max(angle(spectre_stft(:,sec)));
                %Display
                %disp("-tiempo");
                %disp(sec);
                %disp("-valor frequency max ");
                %disp(maximun_frequencies)
                %disp("-fase")
                %disp(phase)

                %Store
                
                store_max_freq = [store_max_freq,maximun_frequencies];
                store_max_phases = [store_max_phases,max_phase];
                store_time = [store_time,sec]; 
                
     end
    
end

%% 
function [matrix_distances] = DistancesCubinder(S1_phase,S1_freq,S1_time, S2_phase,S2_freq,S2_time)
   %Compute distances
   matrix_distances = zeros(size(S1_phase,2),size(S1_phase,2));
   for index1 = 1:size(S1_phase,2)
       for index2 = 1:size(S1_phase,2)
           if (abs(S1_phase(index1) -S2_phase(index2))<=pi)
                  phase_diff = abs(power(((S1_phase(index1))-(S2_phase(index2))),1));
           else
                  %phase_temp = power((point_phase(p1)-point_phase(p2)),2);
                  phase_diff = abs(power((2*pi)-abs((S1_phase(index1))-(S2_phase(index2))),1));
           end
           freq_diff = S1_freq(index1) - S2_freq(index2);
           time_diff = S1_time(index1) - S2_time(index2);
           total_diff = phase_diff + freq_diff - time_diff;
           matrix_distances(index1,index2) = total_diff;
       end
   end
   
end