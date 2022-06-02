classdef BilinearModel < matlab.mixin.SetGet
   properties
        Name = "Bilinear model Tack";
        Instrument;
        Params;
        RawData;
        SMA;
        M1;
   end
   methods
      function value = get.Name(obj)
        value = obj.Name;
      end
      function value = get.Instrument(obj)
        value = obj.Instrument;
      end  
      function value = get.Params(obj)
        value = obj.Params;
      end 
      function value = get.RawData(obj)
        value = obj.RawData;
      end 
      
      function obj = ComputeSimulations(obj)
        %% Model Tak params
        freq = obj.Instrument.SamplingFrequency;     
        
        %% Generate Series
        [U, timestamps] = getinputs(freq, 5, 25, 2); 

        %% DCM start!
        %% Neurodynamics
        [Z] = Neurodynamics(obj.Params.Neurodynamics.A, obj.Params.Neurodynamics.B, obj.Params.Neurodynamics.C, U, 1/freq);

        %% Hemodynamic
        [P,Q] = Hemodynamic(Z, U, obj.Params.Hemodynamic.P_SD, obj.Params.Neurodynamics.A,1/freq);

        %% Optic
        [obj.SMA,obj.M1] = OpticLib( P,Q, U,obj.Params.Neurodynamics.A, obj.Params.Noise.add_noise); 

      end
      
   end
end