classdef Instrument < matlab.mixin.SetGet
   properties
      Name;
      SamplingFrequency;
      Chanels;
      WaveLenght;
      ChannelsNames;
   end
   methods
      function value = get.Name(obj)
        value = obj.Name;
      end
      function value = get.SamplingFrequency(obj)
        value = obj.SamplingFrequency;
      end
      function value = get.Chanels(obj)
        value = obj.Chanels;
      end
      function value = get.WaveLenght(obj)
        value = obj.WaveLenght;
      end
      function value = get.ChannelsNames(obj)
        value = obj.ChannelsNames;
      end
   end
end