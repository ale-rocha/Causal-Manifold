classdef Manifold < matlab.mixin.SetGet
   properties
      Name;
      Description;
      Dimensions;
      Normalized;
      DistanceFunction;
      Signature;
      SetEvents;
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
            [min_phase,max_phase] = obj.SetEvents.RangePhase;
            [min_frequency,max_frequency] = obj.SetEvents.RangeFrequency;
            [min_time,max_time] = obj.SetEvents.RangeTime;
            for p = min_phase:max_phase
                for f = min_frequency:max_frequency
                    for t = min_time:max_time
                        e = Event();
                        e.Phase = p;
                        e.Frequency = f;
                        e.Time = t ;
                        e.PhaseCos = cos(p);
                        e.PhaseSin = sin(p);
                        e.InfoChanel = "grid";
                        grid_events =[grid_events,e];
                    end
                end
            end
            obj.GridStructure=grid_events;
       end
      
      
   end
end