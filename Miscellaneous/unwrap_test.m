t = 0:1/100:10-1/100;

x = sin(2*50*pi*t+1); %+ sin(2*pi*40*t);
plot(x);
shg;


y = fft(x); 
m = abs(y);
pp=angle(y);
p = unwrap(angle(y));
plot(p);