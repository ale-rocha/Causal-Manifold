% Para linealizar el espacio, es necesario desenrollar la fase codificada
% en el rango de 0-2pi.

%Comenzaremos con un ejemplo simple: 
%Generando una señal
fs = 200;
t = 0:1/100:10-1/100;
x = sin(2*pi*t); 
%Calculando STFT
win = hamming(200,'periodic');
[spectre_stft,frequencies_stft,time_stft] = stft(x,'Window',win,'OverlapLength',50);
disp("size time_stft");
disp(size(time_stft));
disp("size frequencies_stft");
disp(size(frequencies_stft));
disp("size spectre_stft");
disp(size(spectre_stft));

for sec = 1:length(time_stft)
 
    [max_energy, index] = max(abs(spectre_stft(length(spectre_stft)/2:length(spectre_stft),sec)));
    a = (spectre_stft(:,sec));
    p = stem(frequencies_stft,angle(spectre_stft(:,sec)));
    plot(frequencies_stft,unwrap(angle(spectre_stft(:,sec))));
    shg;
    pause(5);
    
end

%stem(frequencies_stft,angle(spectre_stft(:,sec)));
                %max(angle(spectre_stft(:,sec)))
