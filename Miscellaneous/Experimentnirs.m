

Fs = 1000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 6;                % seconds
t = (0:dt:StopTime-dt);
   
%Experiment #2 --------------------------------
% Para este experimento, voy a crear 3 series de tiempo identicas
wave1 = sea_waves(9,0);          % Stimulus
wave2 = sea_waves(9,0);          % Stimulus
wave3 = sea_waves(9,0);          % No Stimulus
% A dos de las series les voy a insertar un función sinc como evento
x1 = linspace(-1,1,1000); y1 = sinc((x1)*4);

%Ahora, hay que insertarlas en las series de tiempo analizadas
wave1(2001:3000) = wave1(2001:3000) + (y1.'*2);   %Estimulo1
wave2(3001:4000) = wave2(3001:4000) + (y1.'*2);   %Estimulo2

plot(wave1); hold on;
plot(wave2+2.5);
plot(wave3+5.5);
shg;
%Opcionalmente, agregar ruido

%Analizando los eventos
sea_wave = [];
sea_wave = [sea_wave,wave1];
sea_wave = [sea_wave,wave2];
sea_wave = [sea_wave,wave3];


point_frequency = [];
point_phase =[];
point_time = [];

count_points = 0;
for w = 1:3
    %Calculando el espectro
    win = hamming(1000,'periodic');
    [spectre_stft,frequencies_stft,time_stft]=stft(sea_wave(:,w),seconds(1/1000),'Window',win,'OverlapLength',0);
    for sec = 1:length(time_stft) %For each second
        [max_energy, index] = max(abs(spectre_stft(length(spectre_stft)/2:length(spectre_stft),sec)));
        %Extraer el valor de frecuencia con el indice (index)
        catologue_frequencies = frequencies_stft(length(frequencies_stft)/2:length(frequencies_stft));
        maximun_frequencies = catologue_frequencies(index);  % Frequencia con mayor energia
        % ---- Codigo para obtener la fase -----
        X = spectre_stft(length(spectre_stft)/2:length(spectre_stft));
        X2=X;%store the FFT results in another array
        %detect noise (very small numbers (eps)) and ignore them
        threshold = max(abs(X))/100; %tolerance threshold
        X2(abs(X)<threshold) = 0; %maskout values that are below the threshold
        phase=atan2(imag(X2),real(X2))*180/pi; %phase information

    
        %Display           
        %disp("-tiempo");
        %disp(sec);
        %disp("-valor frequency max ");
        %disp(maximun_frequencies)
        %disp("-fase")
        %disp(max(phase));
        count_points = count_points +1;
        disp("Punto");
        disp(count_points);
        
        if((w==1 && sec==3)||(w==2 && sec==4) || (w==3 && sec == 3) || (w==3 && sec ==4))
        point_frequency = [point_frequency, maximun_frequencies];
        point_phase = [point_phase, max(phase) ];
        point_time = [point_time, sec ];
        end
    
    end
end

distances_matrix = [];
for p1 = 1:length(point_time)
  for p2 = 1:length(point_time)      
      distance = power((point_phase(p1)-point_phase(p2)),2)+  power((point_frequency(p2)-point_frequency(p1)),2) - power((point_time(p1)-point_time(p2)),2);
      if (distance < 0)
          disp("!Causal curve!!!");
          disp(distance);
          disp ("Between points");
          disp(p1);
          disp(p2);
          disp("------------------");
      end
      if (distance == 0 )
          disp("Null related");
          disp(distance);
          disp ("Between points");
          disp(p1);
          disp(p2);
          disp("------------------");
      end
      if (distance > 0)
          disp(" NO Causal curve");
          disp(distance);
          disp ("Between points")
          disp(p1);
          disp(p2);
          disp("------------------");
      end
      distances_matrix = [distances_matrix,distance];
  end
end

distances_matrix = reshape(distances_matrix,[length(point_time),length(point_time)]);
%Debido a que hay distancias negativas, es necesario
%desplazar la matriz algunas unidades
%distances_matrix = (distances_matrix + (abs(min(min(distances_matrix)))+1)) - ((abs(min(min(distances_matrix)))+1)*eye(length(point_time))) ;
%distances_matrix = power(distances_matrix,1/2);

projection = cmdscale(distances_matrix,2);

X = projection(:,1);
Y = projection(:,2);
%Z = projection(:,3);

figure;
c = linspace(1,50,length(X));
scatter(X,Y,60,c,"filled")
shg;



   