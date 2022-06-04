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
thisInstrument.Name="Generic instrument";
thisInstrument.SamplingFrequency=10;
thisInstrument.Chanels = 8;
thisInstrument.WaveLenght = 2;

%Creating BilinearSimulation
CDMconfigurationPath = "/Users/alerocha/Documents/Causal-Manifold/Params/Params_DCM/Tak_config.json";
params_dcm = legacy_BMfiles(CDMconfigurationPath);
thisBilinearModel = BilinearModel();
thisBilinearModel.Name = "Bilinear model Tack";
thisBilinearModel.Instrument = thisInstrument;
thisBilinearModel.Params = params_dcm;
thisBilinearModel.ComputeSimulations; %Run simulations

%Creating events (hereda de simulacion bilineal)
thisEvents = EventsSet();
thisEvents.BilinearModel = thisBilinearModel;
thisEvents.ProyectObservationsToEvents;

%Creating manifold
thisManifold = Manifold ();
thisManifold.Name = "Cubinder";
thisManifold.Dimensions= 4;
thisManifold.Signature= "(3+,1-)";
thisManifold.DistanceFunction = "x+y-z";
thisManifold.Normalized = false;
thisManifold.Description = "Manifold de prueba";
thisManifold.SetEvents = thisEvents;
thisManifold.gridManifold; %poblar el manifold

% %Creating experiment model
thisExperiment = Experiment();
thisExperiment.Name ="Tak Experiment";
thisExperiment.Type="Testing";
thisExperiment.Manifold = thisManifold;


% Visualization
gridManifold = getStructuredEvents(thisManifold.GridStructure);
gridEdges = getStructuredEdges(thisManifold.GridEdgesStructure);
eventsManifold = getStructuredEvents(thisManifold.SetEvents.EventsRaw);

figure;
scatter3(eventsManifold.Phase,eventsManifold.Frequency,eventsManifold.Time,20,eventsManifold.InfoChanel,'filled');
hold on;
scatter3(gridManifold.Phase,gridManifold.Frequency,gridManifold.Time);
xlabel("Phase"); ylabel("Freq"); zlabel("Time");
shg;
%Convertir listas de objetos en arrays

