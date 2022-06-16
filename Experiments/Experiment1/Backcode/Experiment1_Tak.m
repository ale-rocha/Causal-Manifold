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
thisInstrument.SamplingFrequency=100;
thisInstrument.Chanels = 12;
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
thisEvents.FrequencySupRange = 50; 
thisEvents.NormalizedType = "min:0-max:1";

%Creating manifold
thisManifold = Manifold ();
thisManifold.Name = "Cubinder";
thisManifold.Dimensions= 4;
thisManifold.Signature= "(3+,1-)";
thisManifold.DistanceFunction = "x+y-z";
thisManifold.Normalized = false;
thisManifold.Description = "Manifold de prueba";
thisManifold.SetEvents = thisEvents;
DeltaGridPhase = pi/10;
DeltaGridFreq = 5;
DeltaGridTime = 1;
thisManifold.gridManifold(DeltaGridPhase,DeltaGridFreq,DeltaGridTime); %poblar el manifold
thisManifold.computeCausalCones("RawData"); %Calcular conos causales para cada punto

%thisManifold.mappingConextions;

% %Creating experiment model
thisExperiment = Experiment();
thisExperiment.Name ="Tak Experiment";
thisExperiment.Type="Testing";
thisExperiment.Manifold = thisManifold;

% --------------------------------------------------------------------
% Saving input dataseries  -------------------------------------------
namefile = '/Users/alerocha/Documents/Causal-Manifold/Experiments/Experiment1/Outputs/TimeStreams';
mkdir(namefile);
namefile = strcat(namefile,'/');
channels_data = thisBilinearModel.RawObservations; %data
namefileTS = strcat(namefile,'timestreams.csv');
writematrix(channels_data,namefileTS) 
timestamp = thisBilinearModel.Timestamps;
namefileTS = strcat(namefile,'timestamp.csv');
writematrix(timestamp,namefileTS) 
disp("[ 1 ] Channels saved");

%---------------------------------------------------------------------
% Saving manifold events and grid ------------------------------------

% Extracting data ----------------------
namefile = '/Users/alerocha/Documents/Causal-Manifold/Experiments/Experiment1/Outputs/Manifold';
mkdir(namefile);
namefile = strcat(namefile,'/');
gridManifold = getStructuredEvents(thisManifold.GridStructure);
gridEdges = getStructuredEdges(thisManifold.GridEdgesStructure);
eventsManifold = getStructuredEvents(thisManifold.SetEvents.EventsRaw);

% Saving grid ---------------------------
data1 =  [[gridManifold.Phase],
         [gridManifold.PhaseSin],
         [gridManifold.PhaseCos],
         [gridManifold.Frequency],
         [gridManifold.Time],
         [gridManifold.InfoChanel],
         [gridManifold.InfoMeasure],
         [gridManifold.PathCones]];

namefileA = strcat(namefile,'gridManifold.csv');
writematrix(transpose(data1),namefileA);
disp("Saved [ 1 ]");

% Saving grid edges ----------------------
%PhaseA,PhaseB,PhaseCosA,PhaseCosB,PhaseSinA,PhaseSinB,FreqA,FreqB,TimeA,TimeB
data2 = [[gridEdges.PhaseA],
         [gridEdges.PhaseB], 
         [gridEdges.PhaseCosA],
         [gridEdges.PhaseCosB],
         [gridEdges.PhaseSinA],
         [gridEdges.PhaseSinB],
         [gridEdges.FrequencyA],
         [gridEdges.FrequencyB],
         [gridEdges.TimeA],
         [gridEdges.TimeB]];
namefileA = strcat(namefile,'edgesManifold.csv');
writematrix(transpose(data2),namefileA);
disp("Saved [ 2 ]");

% Saving events observations -------------
data3 = [[eventsManifold.Phase],
         [eventsManifold.PhaseSin],
         [eventsManifold.PhaseCos],
         [eventsManifold.Frequency],
         [eventsManifold.Time],
         [eventsManifold.InfoChanel],
         [eventsManifold.InfoMeasure],
         [eventsManifold.PathCones]];
namefileA = strcat(namefile,'eventsManifold.csv');
writematrix(transpose(data3),namefileA);
disp("Saved [ 3 ]");

%Saving causal cones%-----------------------------------------------------------
%-------------------------------------------------------------------------------
for refP = 1:size(thisManifold.CausalCones,2)

    filelocalname = thisManifold.CausalCones(refP).ReferencePoint.PathCones;
    namefile = strcat('/Users/alerocha/Documents/Causal-Manifold/Experiments/Experiment1/Outputs/Cones/',filelocalname);
    mkdir(namefile);
    namefile = strcat(namefile,'/');
    disp("Saved [ 4 ]");
    
    %Saving future cone --------------------------------------------------->
    %PhaseCos,PhaseSin,Phase,Frequency,Time,InfoChanel TODO: Nombres colms
    if size(thisManifold.CausalCones(refP).FutureCone,2) == 0
    namearch = strcat(namefile,"futureCone.csv"); %empty file
    writematrix([],namearch)
    else
    futureCone = [[thisManifold.CausalCones(refP).FutureCone.PhaseCos],
                  [thisManifold.CausalCones(refP).FutureCone.PhaseSin],
                  [thisManifold.CausalCones(refP).FutureCone.Phase],
                  [thisManifold.CausalCones(refP).FutureCone.Frequency],
                  [thisManifold.CausalCones(refP).FutureCone.Time],
                  [thisManifold.CausalCones(refP).FutureCone.InfoChanel],
                  [thisManifold.CausalCones(refP).FutureCone.InfoMeasure]];
    %futureCone = reshape(futureCone,size(thisManifold.CausalCones(refP).FutureCone,2),6);
    namearch = strcat(namefile,"futureCone.csv");
    writematrix(transpose(futureCone),namearch);
    end
    disp("Saved [ 5 ]");

    %Saving past cone ----------------------------------------------------->
    %PhaseCos,PhaseSin,Phase,Frequency,Time,InfoChanel TODO: Nombres colms 
    if size(thisManifold.CausalCones(refP).PastCone,2) == 0
    namearch = strcat(namefile,"pastCone.csv"); %empty file
    writematrix([],namearch)
    else
    pastCone = [[thisManifold.CausalCones(refP).PastCone.PhaseCos],
                [thisManifold.CausalCones(refP).PastCone.PhaseSin],
                [thisManifold.CausalCones(refP).PastCone.Phase],
                [thisManifold.CausalCones(refP).PastCone.Frequency],
                [thisManifold.CausalCones(refP).PastCone.Time],
                [thisManifold.CausalCones(refP).PastCone.InfoChanel],
                [thisManifold.CausalCones(refP).PastCone.InfoMeasure]];
    %pastCone = reshape(pastCone,size(thisManifold.CausalCones(refP).PastCone,2),6);
    namearch = strcat(namefile,"pastCone.csv");
    %T.Properties.VariableNames(1:6) = {'PhaseCos','PhaseSin','Phase','Frequency','Time','InfoChanel'};
    writematrix(transpose(pastCone),namearch);
    end
    disp("Saved [ 6 ]");
    
    %Saving horismos cone ------------------------------------------------->
    %PhaseCos,PhaseSin,Phase,Frequency,Time,InfoChanel TODO: Nombres colms
    if size(thisManifold.CausalCones(refP).Horismos,2) == 0
    namearch = strcat(namefile,"horismosCone.csv"); %empty file
    writematrix([],namearch)
    else
    horismosCone = [[thisManifold.CausalCones(refP).Horismos.PhaseCos],
                    [thisManifold.CausalCones(refP).Horismos.PhaseSin],
                    [thisManifold.CausalCones(refP).Horismos.Phase],
                    [thisManifold.CausalCones(refP).Horismos.Frequency],
                    [thisManifold.CausalCones(refP).Horismos.Time],
                    [thisManifold.CausalCones(refP).Horismos.InfoChanel],
                    [thisManifold.CausalCones(refP).Horismos.InfoMeasure]];
    %horismosCone = reshape(horismosCone,size(thisManifold.CausalCones(refP).Horismos,2),6);
    namearch = strcat(namefile,"horismosCone.csv");
    %T.Properties.VariableNames(1:6) = {'PhaseCos','PhaseSin','Phase','Frequency','Time','InfoChanel'};
    writematrix(transpose(horismosCone),namearch);
    end
    disp("Saved [ 7 ]");
    
    %Saving spacelike cone ------------------------------------------------>
    %PhaseCos,PhaseSin,Phase,Frequency,Time,InfoChanel TODO: Nombres colms
    if size(thisManifold.CausalCones(refP).SpaceLike,2) == 0
    namearch = strcat(namefile,"spacelikeCone.csv"); %empty file
    writematrix([],namearch)
    else
    spacelikeCone = [[thisManifold.CausalCones(refP).SpaceLike.PhaseCos],
                     [thisManifold.CausalCones(refP).SpaceLike.PhaseSin],
                     [thisManifold.CausalCones(refP).SpaceLike.Phase],
                     [thisManifold.CausalCones(refP).SpaceLike.Frequency],
                     [thisManifold.CausalCones(refP).SpaceLike.Time],
                     [thisManifold.CausalCones(refP).SpaceLike.InfoChanel],
                     [thisManifold.CausalCones(refP).SpaceLike.InfoMeasure]];
    %spacelikeCone = reshape(spacelikeCone,size(thisManifold.CausalCones(refP).SpaceLike,2),6);
    namearch = strcat(namefile,"spacelikeCone.csv");
    %T.Properties.VariableNames(1:6) = {'PhaseCos','PhaseSin','Phase','Frequency','Time','InfoChanel'};
    writematrix(transpose(spacelikeCone),namearch); 
    end
    disp("Saved [ 8 ]");
        
end
namefile = '/Users/alerocha/Documents/Causal-Manifold/Experiments/Experiment1/Backcode';
mkdir(namefile);
copyfile /Users/alerocha/Documents/Causal-Manifold/Experiments/Experiment1/Experiment1_Tak.m /Users/alerocha/Documents/Causal-Manifold/Experiments/Experiment1/Backcode/Experiment1_Tak.m
disp("Finished")