fs = 100;
t = 0:1/fs:1-1/fs;
x = sin(2*pi*1*t); %+ cos(2*pi*6*t-pi);
xx =  sin(2*pi*2*t-pi/4);
xxx = sin(2*pi*7*t-pi/4);

%plot(t,x); hold on;
plot(t,xx);hold on;
plot(t,xxx);
shg;


y = fft(x);
z = fftshift(y);

ly = length(y);
f = (-ly/2:ly/2-1)/ly*fs;


tol = 1e-6;
z(abs(z) < tol) = 0;
theta = angle(z);

disp(length(f));

stem(f(length(f)/2:length(f)),theta(length(f)/2:length(f)))
xlabel 'Frequency (Hz)'
ylabel 'Phase / \pi'



%Obteniendo el maximo valor de frecuencia y su fase:

[phase,index] = max(theta);
frequency = f(index);

timeshift = ((phase/pi)*180)/(360*frequency);
disp("timeshift (s)");
disp(timeshift)


