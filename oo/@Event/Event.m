classdef Event < matlab.mixin.SetGet
   properties
      Phase;
      Frequency;
      Time;
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
      
   end
end