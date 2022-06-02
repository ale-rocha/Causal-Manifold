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
samplig_rate = 10;

%Instrument
thisInstrument = Instrument();
thisInstrument.Name="";
thisInstrument.SamplingFrequency=1/10;
thisInstrument.Chanels = 8;
thisInstrument.WaveLenght = 2;
thisInstrument.ChannelsNames = ""

%Creating BilinearSimulation
thisBilinearModel = BilinearModel();
thisBilinearModel.Name = "";
thisBilinearModel.Instrument = thisInstrument;
thisBilinearModel.A
thisBilinearModel.B
thisBilinearModel.C
thisBilinearModel.U
thisBilinearModel.RawData;

%Creating event
thisEvent = Event();
thisEvent.phase 
thisEvent.frequency
thisEvent.time
thisEvent.infoChannel

%Creating events (hereda de simulacion bilineal)
thisEvents = setEvents();
thisEvents.Events = {Event};
thisEvents.thisBilinearModel = thisBilinearModel;

%Creating manifold
thisManifold = Manifold ();
thisManifold.Name = "Cubinder";
thisManifold.Dimensions= 4;
thisManifold.Signature= "(3+,1-)";
thisManifold.DistanceFunction = "x+y-z";
thisManifold.Normalized = false;
thisManifold.Description = "Manifold de prueba";
thisManifold.Events = Events;

%Creating experiment model
thisExperiment = Experiment();
thisExperiment.Name ="Tak Experiment";
thisExperiment.Type="Testing";
thisExperiment.Manifold = thisManifold;



%% [1] Get data from DCM model
%[SMA,M1] = get_BM_by_name("Tak",verbose);


%% [2] Proyectar SFFT
%EventsSet = EventsSet();                        %Create even sets
%EventsSet.Name = "Events set Experiement Tak";
%[phaseM1,senphaseM1, cosphaseM1, freqM1, timeM1] = series_to_fourier(M1,samplig_rate);
%[phaseSMA,senphaseSMA,cosphaseSMA, freqSMA, timeSMA] = series_to_fourier(SMA,samplig_rate);
%scatter3(cosphaseSMA,freqSMA, timeSMA);
%xlabel('phase cos');
%ylabel('freq');
%zlabel('time');
%scatter3(phaseM1, freqM1, timeM1,20,'blue','filled');
%shg;
%% [3] Obtener cubindro normalizado

% [4] Proyectar en cubrindro


