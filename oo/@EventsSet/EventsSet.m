classdef EventsSet < matlab.mixin.SetGet
   properties
      Name;
      Observation;
      Events = {};
   end
   methods
      function value = get.Name(obj)
        value = obj.Name;
      end
      function value = get.Observation(obj)
        value = obj.Observation;
      end   
      
   end
end