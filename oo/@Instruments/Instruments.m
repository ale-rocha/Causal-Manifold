classdef Instruments < matlab.mixin.SetGet
   properties
      samplingRate = 100
      name = "Default"
   end
   methods
      function value = get.samplingRate(obj)
        value = obj.samplingRate;
      end
   end
end