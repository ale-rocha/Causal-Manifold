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
       function obj = gridManifold(obj)
            grid_events = [];
            grid_edges = [];
            min_phase = 0;
            max_phase = 2*pi-pi/10;
            min_frequency = obj.SetEvents.FrequencyMin;
            max_frequency = 7;
            min_time = obj.SetEvents.TimeMin;
            max_time = obj.SetEvents.TimeMax;
            
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
                        g.PhaseB = p+1;
                        g.PhaseCosA = cos(p);
                        g.PhaseCosB = cos(p+1);
                        g.PhaseSinA = sin(p);
                        g.PhaseSinB = sin(p+1);
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