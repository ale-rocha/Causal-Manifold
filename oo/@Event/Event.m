classdef Event < matlab.mixin.SetGet
   properties
      Phase;
      Frequency;
      Time;
      InfoChanel;
   end
   methods
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