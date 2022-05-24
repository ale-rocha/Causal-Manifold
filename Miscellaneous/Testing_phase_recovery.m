
%Recupera correctamente la fase despues de STFT

fs = 100;
t = 0:1/fs:1-1/fs;
x = cos(2*pi*15*t + 0.126);

win = hamming(sample_rate,'periodic');
[y,frequencies_stft,time_stft] = stft(x,sample_rate,'Window',win,'OverlapLength',0);
    
z = fftshift(y);
theta = angle(y(:,1));

stem(frequencies_stft,theta)
xlabel 'Frequency (Hz)'
ylabel 'Phase / \pi'
grid