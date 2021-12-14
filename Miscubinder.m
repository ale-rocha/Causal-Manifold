figure
hold on

h = 1;
r = 1;
    
%Frequencia, fase, tiempo
u =  linspace(0,2*pi,20);  %frecuencia
v = linspace(0,h,20);  %frecuencia
t = linspace(0,h,20);  %frecuencia
[u,f,t] = meshgrid(u,v,t);

distance = 2;
w = 1/distance - 
m=[[w,0,0,0];[0,w,0,0];[0,0,w,0]];
x = r*cos(u);
y = r*sin(u);
    
scatter3(x(:),y(:),t(:))

%Plotting
%s = surf(squeeze(x(:,:,1)),squeeze(y(:,:,1)),squeeze(w(:,:,1)),'FaceAlpha',0.4);
s = surf(squeeze(x(1,:,:)),squeeze(z(1,:,:)),squeeze(w(1,:,:)),'FaceAlpha',0.4);
%s.EdgeColor = 'none';
%colormap(spring);
colormap(winter);
shg;