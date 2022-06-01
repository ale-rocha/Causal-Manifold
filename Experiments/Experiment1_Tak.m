%% [Experiment #1]

%% Autors:
% Instituto Nacional de Astrofísica Óptica y Electrónica
% Departamento de ciencias computacioanles.
% A.Rocha-Solache F.Orihuela-Espina, G.Rodríguez-Gómez
% rochasolache@inaoep.mx

%% Log activity:
% 31 - May - 2021 : Creation file
%   
%% Biblio
% [Tak S.] - Tak,S., Kempny,A., Friston,K.J., Leff,A.P., & Penny,W.D. 
%            (2015). Dynamic causal modelling for functional near-infrared
%            spectroscopy. Neuroimage, 111, 338-349.
%
% En este archivo se generan los resulatdos del primer experientod con
% datos del modelo general lineal.
 
%% PARAMS
verbose = false;
samplig_rate = 100;

%% [1] Get data from DCM model
[SMA,M1] = get_BM_by_name("Tak",verbose);
plot(M1)

%% [2] Proyectar SFFT
EventsSet = EventsSet();                        %Create even sets
EventsSet.Name = "Events set Experiement Tak";
SMA = SMA(:,1);
[phaseM1,senphaseM1, cosphaseM1, freqM1, timeM1] = series_to_fourier(M1,samplig_rate);
[phaseSMA,senphaseSMA,cosphaseSMA, freqSMA, timeSMA] = series_to_fourier(SMA,samplig_rate);
plot3(phaseSMA,freqSMA, timeSMA); hold on;
%scatter3(phaseM1, freqM1, timeM1,20,'blue','filled');
shg;
%% [3] Obtener cubindro normalizado

% [4] Proyectar en cubrindro


