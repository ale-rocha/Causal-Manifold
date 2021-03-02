classdef Point
   properties
      Id 
      TimeSerie 
      Phase 
      Frequency 
      Comments 
   end
   methods
      function r = roundOff(obj)
         r = round([obj.Value],2);
      end
      function r = multiplyBy(obj,n)
         r = [obj.Value] * n;
      end
   end
end