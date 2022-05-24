

function  BilinearPlotThetaA(A,B,C,U,Z,S,OR)
f1=figure;   
set(f1, 'NumberTitle', 'off', ...
    'Name', "Neurodynamic");

% Equation ---------------------
subplot(6,2,2,'parent',f1);
text(0.1,0.5,'Explanation');
set(gca,'visible','off')
% A --------------------------------
subplot(6,2,1,'parent',f1);
h=heatmap(A);
h.title('First-order conectivity [A]');
h.Colormap = parula;
h.ColorbarVisible = 'off';
% B ---------------------------------
subplot(6,2,3,'parent',f1);
h = heatmap(B);
h.title('First-order conectivity [A]');
h.Colormap = parula;
h.ColorbarVisible = 'off';
title('Changes in coupling [Bj][j=1]');

subplot(6,2,4,'parent',f1);
h=heatmap(B);
h.title('First-order conectivity [A]');
h.Colormap = parula;
h.ColorbarVisible = 'off';
title('Changes in coupling [Bj][j=2]');

% C ---------------------------------
subplot(6,2,5,'parent',f1);
h=heatmap(C);
title('Extrinsic influences [C] ');
h.Colormap = parula;
h.ColorbarVisible = 'off';

% Info ---------------------
subplot(6,2,7:8,'parent',f1);
plot(U(1,:)); hold on;
plot(U(2,:)*0.5); hold off;
title('Inputs [U] ');

% Info ---------------------
subplot(6,2,9:10,'parent',f1);
plot(Z(1,:)); hold on;
plot(Z(2,:)); hold off;
title('Neurodynamic output ');

% Info ---------------------
subplot(6,2,11:12,'parent',f1);
plot(S(1,:)); hold on;
plot(S(2,:)); hold off;
title('Hemo output ');

% Info ---------------------
%subplot(6,2,11:12,'parent',f1);
%plot(OR(1,:)); hold on;
%plot(OR(2,:)); hold off;
%title('Optic output ');

end

