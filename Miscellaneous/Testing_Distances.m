



r1 = 1 ;
theta1=0;
z1 = 0;

r2 = 1 ;
theta2=180;
z2 = 1;

theta = linspace(theta1,theta2,50);
rho =  linspace(r1,r2,50);
z =  linspace(z1,z2,50);
theta_radians = deg2rad(theta);
polarplot(theta_radians,rho)

%Distance

distance =  sqrt((r2-r1).^2 + (r2*deg2rad(theta1)-r1*deg2rad(theta2)).^2 +(z2-z1).^2);
disp(distance)