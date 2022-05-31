% Este scrip está diseñado para evaluar la visibilidad de curvas
% causales en un rango de frecuencias y fases.
% Es decir, hay un rango de frecuencias para las cuales el calculo de 
% las distancias del cubindro se saturan en negativas (el cono futuro
% se expande). ¿Cuáles son esas frecuencias?


%% Some params
sampling_rate = 100;
seconds_min = 2; 
seconds_max = 60;  
min_freq = 1;  max_freq = 50;  delta_freq = 1;
min_phase = -pi;  max_phase = pi;  delta_phase = pi/8;

frequencies = linspace(min_freq,max_freq, max_freq-min_freq/delta_freq+1);

%% Iter along phases and frequencies
% Checar que las series de tiempo con la fase
% y frecuencia sean correctas con la frecuencia de 
% muestreo.
phase =0;


time_slides = zeros(100,100,seconds_max-seconds_min);
for timeduration = seconds_min:seconds_max
labels1 = [];
labels2 = [];
sensibility_matrix = zeros(round(max_freq-min_freq/delta_freq)+1,round(max_freq-min_freq/delta_freq)+1);
for index1 =  1:max_freq-min_freq/delta_freq+1
    for index2 = 1:max_freq-min_freq/delta_freq+1
       %Signal 1
       [x1,y1] = wave(frequencies(index1),phase,timeduration,sampling_rate);
       [S1_phase,S1_freq,S1_time] = STFT_Projection(y1, sampling_rate);
       %Signal 2
       [x2,y2] = wave(frequencies(index2),phase,timeduration,sampling_rate);
       [S2_phase,S2_freq,S2_time] = STFT_Projection(y2, sampling_rate);
         
       %Compute distances
       [matrix_distances] = DistancesCubinder(S1_phase,S1_freq,S1_time, S2_phase,S2_freq,S2_time);
       %figure;
       %mymap = [0 1 0
       %         1 0 0];
       %heatmap(matrix_distances,'Colormap', mymap);
       %ylabel(frequencies(index1));
       %xlabel(frequencies(index2));
       %shg;
       matrix_distances = matrix_distances+(2*pi);

       %Count positive and negative distances
       s=sign(matrix_distances);
       ipositif=sum(s(:)>=1);
       inegatif=sum(s(:)<=-1);
       
       %Save value
       sensibility_matrix(index1,index2) = inegatif;
       
    end
end
 disp("Tamanio sensibilidad matrix individial");
       disp(size(sensibility_matrix));
%Visualizate
figure;

h = heatmap(sensibility_matrix,'Colormap', copper);
xlabel("Frecuency wave 1");
ylabel("Frecuency wave 2");
title_duration = string(timeduration);
t = strcat( {'Cubinder sendibility # Negative distances" - Signal duration (s):'},title_duration);
title(t);
shg;
%time_slides(:,:,timeduration) =sensibility_matrix ;
end

csvwrite('Outputs/Dataframes/slides_visibility.csv',time_slides)




