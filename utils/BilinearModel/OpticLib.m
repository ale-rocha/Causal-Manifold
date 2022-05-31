function [Y_R1, Y_R2] = OpticLib(pj, qj, U, A, Noise)
%% [Optic equation] 
% This script make a diferentian optic 
%% Framework
% 
% 
%% Autors:
% Instituto Nacional de Astrofísica Óptica y Electrónica
% Departamento de ciencias computacioanles.
% A.Rocha-Solache F.Orihuela-Espina, G.Rodríguez-Gómez
% rochasolache@inaoep.mx
%% Log activity:
% 14 - Aug - 2021 : Creation file
% 1 - Feb - 2022 : Resolving to do task
%   
%% Biblio
% [Tak S.] - Tak,S., Kempny,A., Friston,K.J., Leff,A.P., & Penny,W.D. 
%            (2015). Dynamic causal modelling for functional near-infrared
%            spectroscopy. Neuroimage, 111, 338-349.
nRegions  = size(A,1);
simulationLength = size(U,2);
% optics parameters
%--------------------------------------------------------------------------
%   N(1) - oxygen saturation                                            SO2
%   N(2) - baseline total-hb concentration [mM]                          P0
%   N(3) - cortical weighting factor                                      w
%--------------------------------------------------------------------------
N = [0.65 71 2]; 
P0 = N(2);
% baseline dxy-hb concentration 
base_hbr = N(2) .* (1 - N(1)); 
nChannels = 6;

dq = zeros(nRegions, simulationLength);
dp = zeros(nRegions, simulationLength);
dh = zeros(nRegions, simulationLength);

M1 = zeros(3, simulationLength);
SMA = zeros(3, simulationLength);

Y_R1 = zeros(nChannels, simulationLength);
Y_R2 = zeros(nChannels, simulationLength);

%
% We are using as L1 = 780nm and as L2 = 850nm (same as STak for the
% second one)
%Based on: Giannoni, L., Lange, F., & Tachtsidis, I. (2020). Investigation of the quantification 
% of hemoglobin and cytochrome-c-oxidase in the exposed cortex with near-infrared hyperspectral imaging: 
% a simulation study. Journal of biomedical optics, 25(4), 046001.
extintion1=0.23;
extintion2=0.88;
F_P =[(extintion1*0.0007358251*7.5) (extintion2*0.001104715*6.5) ; (extintion1*0.001159306*7.5) (extintion2*0.0007858993*6.5);
      (extintion1*0.000659306*7.3) (extintion2*0.0001258993*6.5); (extintion1*0.001159306*8.3) (extintion2*0.0009858993*6.9);
       (extintion1*0.0006959306*7.2) (extintion2*0.0001858993*6.1);  (extintion1*0.001059306*7.5) (extintion2*0.0003858993*7.7)]; 
%735.8251 1104.715  = 780nm
%1159.306 785.8993 = 850nm
%disp(cond(F_P));
    for t = 1:simulationLength
        % calculate changes in hemoglobin concentration
        dp(:,t) = (pj(:,t) - 1) * P0; % total Hb
        dq(:,t) = (qj(:,t)-1) * base_hbr; % dxy-Hb
        dh(:,t) = dp(:,t) - dq(:,t); % oxy-Hb
        
        dhq_r1 = [dh(1,t);dq(1,t)]; %DH y DQ de M1
        dhq_r2 = [dh(2,t);dq(2,t)]; %DH y DQ de SMA
        
        M1(:,t) = [dp(1,t);dq(1,t);dh(1,t)];
        SMA(:,t) = [dp(2,t);dq(2,t);dh(2,t)];
        
        %Optics
        disp("Size dhq_r1");
        disp(size(dhq_r1));
        disp("Size matrix sensibility: ");
        disp(size(F_P));
        Y_R1(:,t) = F_P * dhq_r1; 
        Y_R2(:,t) = F_P * dhq_r2;
    end
    

    
    
    %Just plotting
    %noiseSigma = Noise * Y_R1;
    %noise = noiseSigma .* randn(1, length(Y_R1));
    %Y_R1 = Y_R1 + noise;

    %disp("size of this");
    %disp(size(Y_R1))


    ax = axes;
    %ax.ColorOrder = [1 0 0;1 0 0;1 0 0; 0 0 1;0 0 1;0 0 1];
    gap_1 = transpose(Y_R1);
    gap_2 = gap_1(1,:);
    YR1 = transpose(Y_R1)-gap_2;
    y = awgn(YR1,12,'measured');
    hold on;
    for i = 1:6
        plot(y(:,i), 'LineWidth', 2);
    end
    hold off;
    title('M1');
    legend({'WL 1','WL 1','WL 1','WL 2','WL 2','WL 2'},'Location','southwest');
    ylabel('Optical Density'); 
    xlabel('Time [S]');
    shg;
    
    figure
    gap_1 = transpose(Y_R2);
    gap_2 = gap_1(1,:);
    YR2 = transpose(Y_R2)-gap_2;
    y = awgn(YR2,12,'measured');
    plot(y, 'LineWidth', 1);
    title('SMA ');
      legend({'WL 1','WL 1','WL 1','WL 2','WL 2','WL 2'},'Location','southwest');
    ylabel('Optical Density'); 
    xlabel('Time [S]');
    shg;

    %figure
    %gap_1 = transpose(M1);
    %gap_2 = gap_1(1,:);
    %plot(transpose(M1)-gap_2, 'LineWidth', 1);
    %title('M1 Heamoglobin Concentration');
    %legend({'HbT','HbR', 'HbO2'},'Location','southwest');
    %ylabel('Heamoglobin Concentration [\mu M]'); 
    %xlabel('Time [S]');
    %shg;
    %figure
    %gap_1 = transpose(SMA);
    %gap_2 = gap_1(1,:);
    %plot(transpose(SMA)-gap_2,'LineWidth', 1);
    %title('SMA Heamoglobin Concentration');
    %legend({'HbT','HbR', 'HbO2'},'Location','southwest');
    %ylabel(' Heamoglobin Concentration [\mu M]'); 
    %xlabel('Time [S]');
    %shg;
    
    %Bulding the return
    Y = [Y_R1; Y_R2];
end

