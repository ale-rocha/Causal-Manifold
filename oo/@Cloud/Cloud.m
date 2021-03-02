classdef Cloud
   properties
      Id 
      Points = []
      DistancesPNorm1
      DistancesPNorm2
      DistancesPNorm5
      DistancesPNorm100
      DistancesCosine
      DistancesCylindrical
      DistancesCorrelation
      DistancesWincherter
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