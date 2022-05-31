classdef Projection < matlab.mixin.SetGet
   properties
      Id 
      Name
      NameRelations
      X
      Y
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