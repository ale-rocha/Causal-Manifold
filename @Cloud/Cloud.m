classdef Cloud < matlab.mixin.SetGet
   properties
      Id 
      Points = []
      Matrix_Distances = []
   end
   methods
      function value = get.Points(obj)
        value = obj.Points;
      end
      function value = get.Id(obj)
        value = obj.Id;
      end
     
      
   end
end