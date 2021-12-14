

function  BilinearPlotTheta(A,B,C,U)
f1=figure;   
set(f1, 'NumberTitle', 'off', ...
    'Name', "Neurodynamic");

% Equation ---------------------
subplot(5,2,2,'parent',f1);
text(0.1,0.5,'Explanation');
set(gca,'visible','off')
% A --------------------------------
subplot(5,2,1,'parent',f1);
h=heatmap(A);
h.title('First-order conectivity [A]');
h.Colormap = parula;
h.ColorbarVisible = 'off';
% B ---------------------------------
subplot(5,2,3,'parent',f1);
h = heatmap(B{1});
h.title('First-order conectivity [A]');
h.Colormap = parula;
h.ColorbarVisible = 'off';
title('Changes in coupling [Bj][j=1]');

subplot(5,2,4,'parent',f1);
h=heatmap(B{2});
h.title('First-order conectivity [A]');
h.Colormap = parula;
h.ColorbarVisible = 'off';
title('Changes in coupling [Bj][j=2]');

% C ---------------------------------
subplot(5,2,5,'parent',f1);
h=heatmap(C);
title('Extrinsic influences [C] ');
h.Colormap = parula;
h.ColorbarVisible = 'off';

% U ---------------------
subplot(5,2,7:8,'parent',f1);
plot(U(1,:));
title("Inputs [U1]")
% U ---------------------
subplot(5,2,9:10,'parent',f1);
plot(U(2,:));
title("Inputs [U2]")
end

