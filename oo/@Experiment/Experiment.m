classdef Experiment < matlab.mixin.SetGet
   properties
      Name;
      Date = datetime('today');
      Autor;
      Type;
      Description;
      Manifold;
   end
   methods
       %Gets
       function value = get.Name(obj)
        value = obj.Name;
       end
       function value = get.Date(obj)
        value = obj.Observation;
       end 
       function value = get.Autor(obj)
        value = obj.Observation;
       end 
       function value = get.Type(obj)
        value = obj.Type;
       end 
        function value = get.Description(obj)
        value = obj.Description;
        end 
       function value = get.Manifold(obj)
        value = obj.Manifold;
       end
      
   end
end