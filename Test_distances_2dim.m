fs = 10;
t = 0:1/fs:4-1/fs;

x = besselj(0,600*(sin(2*pi*(t+1).^3/30).^5));

plot(t,x)