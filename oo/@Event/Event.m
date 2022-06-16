classdef Event < matlab.mixin.SetGet
   properties
      Phase;
      Frequency;
      Time;
      PhaseCos;
      PhaseSin;
      InfoChanel;
      InfoMeasure;
      PathCones;
      AuxVarDistance;
   end
   methods
      function value = get.PathCones(obj)
        value = obj.PathCones;
      end
      function value = get.AuxVarDistance(obj)
        value = obj.AuxVarDistance;
      end
      function value = get.InfoMeasure(obj)
        value = obj.InfoMeasure;
      end
      function value = get.Phase(obj)
        value = obj.Phase;
      end
      function value = get.Frequency(obj)
        value = obj.Frequency;
      end   
      function value = get.Time(obj)
        value = obj.Time;
      end   
       function value = get.InfoChanel(obj)
        value = obj.InfoChanel;
      end
   end
end