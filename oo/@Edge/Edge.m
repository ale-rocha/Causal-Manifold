classdef Edge < matlab.mixin.SetGet
   properties
      PhaseA;
      PhaseB;
      PhaseCosA;
      PhaseCosB;
      PhaseSinA;
      PhaseSinB;
      FrequencyA;
      FrequencyB;
      TimeA;
      TimeB;
   end
   methods
      function value = get.PhaseA(obj)
        value = obj.PhaseA;
      end
      function value = get.PhaseB(obj)
        value = obj.PhaseB;
      end
      function value = get.PhaseCosA(obj)
        value = obj.PhaseCosA;
      end
      function value = get.PhaseCosB(obj)
        value = obj.PhaseCosB;
      end
      function value = get.PhaseSinA(obj)
        value = obj.PhaseSinA;
      end
      function value = get.PhaseSinB(obj)
        value = obj.PhaseSinB;
      end
      function value = get.FrequencyA(obj)
        value = obj.FrequencyA;
      end   
      function value = get.FrequencyB(obj)
        value = obj.FrequencyB;
      end   
      function value = get.TimeA(obj)
        value = obj.TimeA;
      end   
      function value = get.TimeB(obj)
        value = obj.TimeB;
      end   
     
   end
end