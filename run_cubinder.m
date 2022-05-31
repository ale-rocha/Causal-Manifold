% arocha@inaoep
% Este script ejecuta el cubindro con seniales elementales.

clear variables;
%Crear objecto nube de puntos
% phase, frequency, time
point_phase = [];
point_frequency = [];
point_time = [];
colors_cone = [];


temp = [];
ids = 0;

sampling_rate = 1/1000;

numberseries = 0;

experiments = [1,2,2];


for phase = pi/7:pi:2*pi
    disp("Number series --------");
    disp(numberseries);
    numberseries = numberseries + 1;
    for freq = 1:1:5
  
        wave = sea_waves(freq,phase); 
        
        % Object creation 
       
        
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

%Computing color for causality cone
point_pivot.time = 2;
point_pivot.frequency = 3;
point_pivot.phase = pi/7;



for tindex = 1:length(point_time)
   for pindex = 1:length(point_phase)
        for findex = 1:length(point_frequency)
            distance = parDistancesCubinder(point_phase(pindex),point_frequency(findex),point_time(tindex),point_pivot.phase,point_pivot.frequency,point_pivot.time);
            if distance > 0
                colors_cone = [colors_cone,0];
            elseif distance == 0
                colors_cone = [colors_cone,1];
            elseif distance < 0
                colors_cone = [colors_cone,2];
            end
            disp(distance);
         end
   end
end

colors_cone = reshape(colors_cone,length(point_phase),length(point_frequency),length(point_time));
%-----------------------------------------------------------------------------
% Ploteando algunas proyecciones del cubindro
figure;
x1=cos(point_phase);
x2=sin(point_phase);
disp("-----------*****")
disp(x1);
disp("-----------*****")
disp(colors_cone);
colormap(colors_cone);
shp = alphaShape(x1(:),x2(:),point_frequency(:),10);
S = linspace(20,80,length(x1));
plot(shp,'FaceColor','blue','FaceAlpha',0.1,'EdgeAlpha', 0.1,'LineWidth', 0.1); hold on;
scatter3(x1,x2,point_frequency,13,colors_cone,'filled')
colormap(jet)
zlabel('frequency')
xlabel('phase')
ylabel('phase')
shg;



function [total_diff] = parDistancesCubinder(S1_phase,S1_freq,S1_time, S2_phase,S2_freq,S2_time)
   %Compute distances
 
           if ((abs(S1_phase -S2_phase))<=pi)
                  phase_diff = abs(power(((S1_phase)-(S2_phase)),1));
           else
                  phase_diff = abs(power((2*pi)-abs((S1_phase)-(S2_phase)),1));
           end
           %phase_diff =power(abs(S1_phase-S2_phase),2);
           freq_diff = power(abs(S1_freq - S2_freq),1);
           time_diff = (S1_time - S2_time);
           total_diff = power(abs(phase_diff) + abs(freq_diff),1) - abs(time_diff);
end

