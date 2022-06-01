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
[phaseM1, freqM1, timeM1] = series_to_fourier(M1,samplig_rate);
[phaseSMA, freqSMA, timeSMA] = series_to_fourier(SMA,samplig_rate);
scatter3(phaseSMA,freqSMA, timeSMA,20,timeSMA,'filled');
scatter3(phaseM1, freqM1, timeM1,20,timeM1,'filled');
shg;
%% [3] Obtener cubindro normalizado

% [4] Proyectar en cubrindro


