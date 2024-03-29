%% Utils projections -------------------------------------------------------------------------

function [store_max_phases, store_max_freq, store_time] = STFT_Projection(signal, sample_rate)
    % Project the signals to phase, frequency and time
    %
    %
    %
    %
    %
    % Log : 6-Feb-2022@arocha : Creacion del archivo en carpeta fourier
    
    %Computing signal duration
    ntimesteps = check_timesteps(signal);
    duration = ntimesteps/sample_rate;
    %round seconds
    duration = round(duration);
  
    signal = signal(1:duration*sample_rate);
    
    store_max_freq = [];
    store_max_phases = [];
    store_time = [];
    
    win = hamming(sample_rate,'periodic');
    %win= kaiser(100,20);
    [spectre_stft,frequencies_stft,time_stft] = stft(signal,sample_rate,'Window',win,'OverlapLength',0);
    figure;
    stft(signal,sample_rate,'Window',win,'OverlapLength',0);
    shg;
    %Now, it is necesary save the max frequency and phase of each second
    time_stft = round(time_stft);
    %plot(frequencies_stft,spectre_stft);
    %shg;

    
    for sec = 1:length(time_stft) %For each second
            
                %Extrayendo el índice correspondiente al valor maximo de
                %energía registrada
                %Ojo. Se toma solo la parte positiva del especto, por eso
                %el: spectre_stft)/2:length(spectre_stft) -> Es la segunda
                %mitad del espectro
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
                max_phase = get_phase(frequencies_stft, spectre_stft, maximun_frequencies,sec);
                
                %Store
                store_max_freq = [store_max_freq,maximun_frequencies];
                store_max_phases = [store_max_phases,max_phase];
                store_time = [store_time,sec]; 
                
     end
    
end




