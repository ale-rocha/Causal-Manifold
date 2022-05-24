clc; clf
p=0.199;% Pitch distance
a=0.02999500;% Radius of the helis wire
b=0.191; %Radius of the helix
n = 5; %is the number of turns. 

del = atan(p/(2*pi*b));
u=linspace(0, 2*pi, 10); % correct range, practical number of points
v=linspace(0, 2*pi*n, 300); % practical number of points
[u,v]=meshgrid(u,v);
x1 = b + a*cos(u); % u, not delta
x2 = -a*sin(u)*sin(del);
x = (x1.*sin(v))+(x2.*cos(v)); % elementwise mult
y =(-x1.*cos(v))+(x2.*sin(v)); % elementwise mult
z = ((p*v)/(2*pi))+(a*sin(u)*cos(del));
h=surf(x, y, z);
title('3D Image of Helix')
zlabel('Height')
axis equal % otherwise it gets stretched out
% make it fancy
axis off
shading flat
lightangle(-90,30)
h.FaceLighting = 'gouraud';
h.SpecularStrength = 0.5;
h.AmbientStrength = 0.3;
h.DiffuseStrength = 0.9;