Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sampling period
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector

X = cos(2*pi*100*t);          % First row wave

figure;
plot(t,X)
shg;

n = 2^nextpow2(L);
dim = 2;
Y = fft(X,n,dim);

P2 = abs(Y/L);
P1 = P2(1:n/2+1);
P1(2:end-1) = 2*P1(2:end-1);

%[s,f,t]=stft(X,1000);
%P2 = abs(f/L);
%P1 = P2(:,1:n/2+1);
%P1(:,2:end-1) = 2*P1(:,2:end-1);

figure;
plot(0:(Fs/n):(Fs/2-Fs/n),P1(1:n/2))
shg;

figure;
[ss,f,t]=stft(X,1000);
stft(X,1000);
shg;


for p = 1:length(t)
    control = ss(:,p);
    [indice, valormax] = max(abs(control));
    frecuencia_correcta = f(valormax);
    disp("--------tiempo");
    disp(p);
    disp("-----------valor max ");
    disp(int16(abs(frecuencia_correcta)-2))
    disp("------------- fase")
    disp(max(angle(s(:,p))))
end