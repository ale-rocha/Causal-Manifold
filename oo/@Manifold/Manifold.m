classdef Manifold < matlab.mixin.SetGet
   properties
      Name;
      Description;
      Dimensions;
      Normalized;
      DistanceFunction;
      Signature;
      SetEvents;
      GridEdgesStructure;
      GridStructure;
      Conex;
      CausalCones; %Aqui se almacenan puntos de referencias y conos de causalidad
   end
   methods
       %Gets
       function value = get.Name(obj)
        value = obj.Name;
       end
       function value = get.Description(obj)
        value = obj.Description;
       end
       function value = get.Normalized(obj)
        value = obj.Normalized;
       end
       function value = get.DistanceFunction(obj)
        value = obj.DistanceFunction;
       end
       function value = get.Signature(obj)
        value = obj.Signature;
       end
       function value = get.Dimensions(obj)
        value = obj.Dimensions;
       end
       
       function conex = mappingConextions(obj)
           
            conex = [];
            Ais = false;
            Bis = false;
            for i = 1:size(obj.GridEdgesStructure,2)
                 p1 = obj.GridEdgesStructure(i).PhaseA;
                 p2 = obj.GridEdgesStructure(i).PhaseB;
                 f1 = obj.GridEdgesStructure(i).FrequencyA;
                 f2 = obj.GridEdgesStructure(i).FrequencyB;
                 t1 = obj.GridEdgesStructure(i).TimeA;
                 t2 = obj.GridEdgesStructure(i).TimeB;
                 disp(i);
                 for r = 1:size(obj.GridStructure,2)
                     if Ais == true && Bis == true
                         Ais = false;
                         Bis = false;
                         break;
                     end
                     rp = obj.GridStructure(r).Phase;
                     fp = obj.GridStructure(r).Frequency;
                     tp = obj.GridStructure(r).Time;
                     if p1==rp && f1==fp && t1==tp
                         tempA = r-1;
                         Ais = true;
                         tempConex.A = tempA;
                     end
                     if p2==rp && f2==fp && t2==tp
                         tempB = r-1;
                         tempConex.B = tempB;
                         Bis = true;
                     end
                 end
                 conex = [conex,tempConex];
            end
            obj.Conex = conex;
       end      
       
       function obj = computeCausalCones(obj,rawdataType)
           if rawdataType == "RawData"
               causal_cones = [];
               for eRef = 1:size(obj.SetEvents.EventsRaw,2)
                    myFutureCone = [];
                    mySpaceLikeCone = [];
                    myHorismosCone = [];
                    myPastCone = [];
                    for e = 1:size(obj.SetEvents.EventsRaw,2)
                        distance = abs((obj.SetEvents.EventsRaw(eRef).Phase - obj.SetEvents.EventsRaw(e).Phase))+abs((obj.SetEvents.EventsRaw(eRef).Frequency - obj.SetEvents.EventsRaw(e).Frequency))-abs((obj.SetEvents.EventsRaw(eRef).Time - obj.SetEvents.EventsRaw(e).Time));
                        if distance < 0 
                            myFutureCone = [myFutureCone,obj.SetEvents.EventsRaw(e)];
                        elseif distance < 0 && (obj.SetEvents.EventsRaw(eRef).Time > obj.SetEvents.EventsRaw(e).Time)
                            myPastCone = [myPastCone,obj.SetEvents.EventsRaw(e)];
                        elseif distance > 0
                            mySpaceLikeCone = [mySpaceLikeCone,obj.SetEvents.EventsRaw(e)];
                        elseif distance == 0 
                            myHorismosCone = [myHorismosCone,obj.SetEvents.EventsRaw(e)];
                        end
                    end
                    cone.ReferencePoint = obj.SetEvents.EventsRaw(eRef);
                    cone.FutureCone = myFutureCone;
                    cone.PastCone = myPastCone;
                    cone.SpaceLike = mySpaceLikeCone;
                    cone.Horismos = myHorismosCone;
                    cone.Distance = distance;
                    causal_cones = [causal_cones,cone];
               end
               obj.CausalCones = causal_cones;
           
           elseif rawdataType == "Normalized" 
               causal_cones = [];
               for eRef = 1:size(obj.SetEvents.EventsRawNormalized,2)
                    myFutureCone = [];
                    mySpaceLikeCone = [];
                    myHorismosCone = [];
                    myPastCone = [];
                    for e = 1:size(obj.SetEvents.EventsRawNormalized,2)
                        distance = abs((obj.SetEvents.EventsRawNormalized(eRef).Phase - obj.SetEvents.EventsRawNormalized(e).Phase))+abs((obj.SetEvents.EventsRawNormalized(eRef).Frequency - obj.SetEvents.EventsRawNormalized(e).Frequency))-abs((obj.SetEvents.EventsRawNormalized(eRef).Time - obj.SetEvents.EventsRawNormalized(e).Time));
                        if distance < 0 
                            myFutureCone = [myFutureCone,obj.SetEvents.EventsRawNormalized(e)];
                        elseif distance < 0 && (obj.SetEvents.EventsRawNormalized(eRef).Time > obj.SetEvents.EventsRawNormalized(e).Time)
                            myPastCone = [myPastCone,obj.SetEvents.EventsRawNormalized(e)];
                        elseif distance > 0
                            mySpaceLikeCone = [mySpaceLikeCone,obj.SetEvents.EventsRawNormalized(e)];
                        elseif distance == 0 
                            myHorismosCone = [myHorismosCone,obj.SetEvents.EventsRawNormalized(e)];
                        end
                    end
                    cone.ReferencePoint = obj.SetEvents.EventsRawNormalized(eRef);
                    cone.FutureCone = myFutureCone;
                    cone.PastCone = myPastCone;
                    cone.SpaceLike = mySpaceLikeCone;
                    cone.Horismos = myHorismosCone;
                    cone.Distance = distance;
                    causal_cones = [causal_cones,cone];
               end
               obj.CausalCones = causal_cones;
               
           end
       end
       
       
       
       function obj = gridManifold(obj)
            grid_events = [];
            grid_edges = [];
            min_phase = 0;
            max_phase = 2*pi-pi/10;
            min_frequency = obj.SetEvents.FrequencyMin;
            max_frequency = 7;
            min_time = obj.SetEvents.TimeMin;
            max_time = obj.SetEvents.TimeMax;
            
            conexion_index = 0;
            
            for p = min_phase:pi/10:max_phase
                for f = 0:max_frequency
                    for t = 0:max_time
                        %Event declaration
                        e = Event();
                        e.Phase = p;
                        e.Frequency = f;
                        e.Time = t ;
                        e.PhaseCos = cos(p);
                        e.PhaseSin = sin(p);
                        e.InfoChanel = "grid";
                        grid_events =[grid_events,e];
                        
                        %Edge declarations
                        g = Edge();
                        g.PhaseA = p;
                        g.PhaseB = p+(pi/10);
                        g.PhaseCosA = cos(p);
                        g.PhaseCosB = cos(p+(pi/10));
                        g.PhaseSinA = sin(p);
                        g.PhaseSinB = sin(p+(pi/10));
                        g.FrequencyA = f;
                        g.FrequencyB = f+1;
                        g.TimeA = t;
                        g.TimeB = t+1;
                        if p == max_phase  %Correction to conect circle
                            g.PhaseB = min_phase;
                        end

                        grid_edges = [grid_edges,g];
                        
                    end
                end
            end
            
            
            
            obj.GridStructure=grid_events;
            obj.GridEdgesStructure = grid_edges;
       end
      
      
   end
end