
u = 1;
l = 2;
t = 0.5;
ParametricPlot3D[{{0.1*u Sin[l*t], 0.1*u Cos[l*t],t/(2*\[Pi])},
                  {0.1*u Sin[l*t + 2/3*Pi], 0.1*u Cos[l*t + 2/3*Pi], t/(2*\[Pi])},
                  {0.1*u Sin[l*t + 4/3*Pi], 0.1*u Cos[l*t + 4/3*Pi], t/(2*\[Pi])}
                 }, {t, 0, 2*\[Pi]}, {u, 0, 1}]