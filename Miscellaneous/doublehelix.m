figure

t=(1:0.05:7);
x=(1./t).*sin(2*pi*t);
y=(1./t).*cos(2*pi*t);
h=t;

x1=-(1./t).*sin(2*pi*t);
y1=-(1./t).*cos(2*pi*t);
h1=t;

for i = 1:length(t)-1

p1 = [x(i) x(i+1) 0];

p2 = [y(i) y(i+1) 0];

p3 = [h(i) h(i+1) (h(i)+h(i+1))/2];

p4 = [x1(i) x1(i+1) 0];

p5 = [y1(i) y1(i+1) 0];

p6 = [h1(i) h1(i+1) (h1(i)+h1(i+1))/2];


hold on

fill3(p1,p2,p3,[1 1 1])
fill3(p4,p5,p6,[1 1 1])

end