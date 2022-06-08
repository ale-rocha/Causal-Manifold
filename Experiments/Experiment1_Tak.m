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
thisManifold.computeCausalCones; %Calcular conos causales para cada punto
%thisManifold.mappingConextions;

% %Creating experiment model
thisExperiment = Experiment();
thisExperiment.Name ="Tak Experiment";
thisExperiment.Type="Testing";
thisExperiment.Manifold = thisManifold;

% --------------------------------------------------------------------
% Saving input dataseries  -------------------------------------------
channels_data = thisBilinearModel.RawObservations;
writematrix(channels_data,'Beauty_visualization/channels_data.csv') 
disp("[ 1 ] Channels saved");

%---------------------------------------------------------------------
% Saving manifold events and grid ------------------------------------
% Extracting data ----------------------
gridManifold = getStructuredEvents(thisManifold.GridStructure);
gridEdges = getStructuredEdges(thisManifold.GridEdgesStructure);
eventsManifold = getStructuredEvents(thisManifold.SetEvents.EventsRaw);
% Saving grid ---------------------------
data1 = [[gridManifold.PhaseCos],[gridManifold.PhaseSin],[gridManifold.Phase],[gridManifold.Frequency],[gridManifold.Time]];
data1 = reshape(data1,size(gridManifold.Phase,2),5);
writematrix(data1,'Beauty_visualization/gridManifold.csv') 
% Saving grid edges ----------------------
%PhaseA,PhaseB,PhaseCosA,PhaseCosB,PhaseSinA,PhaseSinB,FreqA,FreqB,TimeA,TimeB
data2 = [gridEdges.PhaseA,gridEdges.PhaseB,gridEdges.PhaseCosA,gridEdges.PhaseCosB,gridEdges.PhaseSinA,gridEdges.PhaseSinB,gridEdges.FrequencyA,gridEdges.FrequencyB,gridEdges.TimeA,gridEdges.TimeB];
data2 = reshape(data2,size(gridEdges.PhaseA,2),10);
writematrix(data2,'edgesManifold.csv') 
% Saving events observations -------------
data3 = [[eventsManifold.Phase],[eventsManifold.Frequency],[eventsManifold.Time]];
data3 = reshape(data3,size(eventsManifold.Phase,2),3);
writematrix(data3,'Beauty_visualization/eventsManifold.csv') 
% -----------------------------------------------------------------------------
%------------------------------------------------------------------------------

%Saving causal cones%-----------------------------------------------------------
%-------------------------------------------------------------------------------
for refP = 1:size(thisManifold.CausalCones,2)
    disp("ref point cone");
    disp(string(thisManifold.CausalCones(refP).ReferencePoint.InfoChanel));
    %Guardamos archivo
    freqname = strcat("Ch_",string(thisManifold.CausalCones(refP).ReferencePoint.InfoChanel));
    timename = strcat("_Time_",string(thisManifold.CausalCones(refP).ReferencePoint.Time));
    namefile = strcat(freqname,timename);
    namefile = strcat('/Users/alerocha/Documents/Causal-Manifold/Experiments/ConesExperiment1/',namefile);
    mkdir(namefile);
    namefile = strcat(namefile,'/');
  
    
    %Saving future cone -------------------------->
    %PhaseCos,PhaseSin,Phase,Frequency,Time,InfoChanel TODO: Nombres colms
    futureCone = [thisManifold.CausalCones(refP).FutureCone.PhaseCos,thisManifold.CausalCones(refP).FutureCone.PhaseSin,thisManifold.CausalCones(refP).FutureCone.Phase,thisManifold.CausalCones(refP).FutureCone.Frequency,thisManifold.CausalCones(refP).FutureCone.Time,thisManifold.CausalCones(refP).FutureCone.InfoChanel];
    futureCone = reshape(futureCone,size(thisManifold.CausalCones(refP).FutureCone,2),6);
    namearch = strcat(namefile,"futureCone.csv");
    writematrix(futureCone,namearch) 

    %Saving past cone -------------------------->
    %PhaseCos,PhaseSin,Phase,Frequency,Time,InfoChanel TODO: Nombres colms 
    %pastCone = [thisManifold.CausalCones(refP).PastCone.PhaseCos,thisManifold.CausalCones(refP).PastCone.PhaseSin,thisManifold.CausalCones(refP).PastCone.Phase,thisManifold.CausalCones(refP).PastCone.Frequency,thisManifold.CausalCones(refP).PastCone.Time,thisManifold.CausalCones(refP).PastCone.InfoChanel];
    %pastCone = reshape(pastCone,size(thisManifold.CausalCones(refP).PastCone,2),6);
    %namearch = strcat(namefile,"pastCone.csv");
    %writematrix(futureCone,namearch) 
    
    %Saving horismos cone -------------------------->
    %PhaseCos,PhaseSin,Phase,Frequency,Time,InfoChanel TODO: Nombres colms
    horismosCone = [thisManifold.CausalCones(refP).Horismos.PhaseCos,thisManifold.CausalCones(refP).Horismos.PhaseSin,thisManifold.CausalCones(refP).Horismos.Phase,thisManifold.CausalCones(refP).Horismos.Frequency,thisManifold.CausalCones(refP).Horismos.Time,thisManifold.CausalCones(refP).Horismos.InfoChanel];
    horismosCone = reshape(horismosCone,size(thisManifold.CausalCones(refP).Horismos,2),6);
    namearch = strcat(namefile,"horismosCone.csv");
    writematrix(horismosCone,namearch) 
    
    %Saving spacelike cone -------------------------->
    %PhaseCos,PhaseSin,Phase,Frequency,Time,InfoChanel TODO: Nombres colms
    spacelikeCone = [thisManifold.CausalCones(refP).SpaceLike.PhaseCos,thisManifold.CausalCones(refP).SpaceLike.PhaseSin,thisManifold.CausalCones(refP).SpaceLike.Phase,thisManifold.CausalCones(refP).SpaceLike.Frequency,thisManifold.CausalCones(refP).SpaceLike.Time,thisManifold.CausalCones(refP).SpaceLike.InfoChanel];
    spacelikeCone = reshape(spacelikeCone,size(thisManifold.CausalCones(refP).SpaceLike,2),6);
    namearch = strcat(namefile,"spacelikeCone.csv");
    writematrix(spacelikeCone,namearch) 
        
end
