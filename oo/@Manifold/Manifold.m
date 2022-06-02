classdef Manifold < matlab.mixin.SetGet
   properties
      Name;
      Description;
      Dimensions;
      Normalized;
      DistanceFunction;
      Signature;
      PopulationGrid;
      SetEvents;
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
       function value = get.PopulationGrid(obj)
        value = obj.PopulationGrid;
       end
      
      
   end
end