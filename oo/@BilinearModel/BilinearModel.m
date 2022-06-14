classdef BilinearModel < matlab.mixin.SetGet
   properties
        Name = "Bilinear model Tack";
        Instrument;
        Timestamps;
        Params;
        RawObservations;
        Channels;
        Seconds;
        Zones;
   end
   methods
      function value = get.Name(obj)
        value = obj.Name;
      end
      function value = get.Timestamps(obj)
        value = obj.Timestamps;
      end
      function value = get.Instrument(obj)
        value = obj.Instrument;
      end  
      function value = get.Params(obj)
        value = obj.Params;
      end 
      function value = get.RawObservations(obj)
        value = obj.RawObservations;
      end 
      
      function obj = ComputeSimulations(obj)
        %% Model Tak params
        freq = obj.Instrument.SamplingFrequency;     
        
        %% Generate Series
        [U, timestamps] = getinputs(freq, 5, 25, 2); 
        obj.Timestamps = timestamps;
        obj.Channels =4;
        obj.Zones =2;
        obj.Seconds =round(size(U,2)/freq);

        %% DCM start!
        %% Neurodynamics
        [Z] = Neurodynamics(obj.Params.Neurodynamics.A, obj.Params.Neurodynamics.B, obj.Params.Neurodynamics.C, U, 1/freq);

        %% Hemodynamic  
        %[P,Q] = Hemodynamic(Z, U, obj.Params.Hemodynamic.P_SD, obj.Params.Neurodynamics.A,1/freq);
        

        %% Optic
        [SMA,M1] = OpticLib( P,Q, U,obj.Params.Neurodynamics.A, obj.Params.Noise.add_noise);
        %obj.RawObservations = [SMA,M1];
        %% Optic master
        [OR,respuesta] = OpticLicMaster( P,Q,obj.Params.Neurodynamics.A); 
        disp("respuesta.lambda1");
        disp(size(respuesta.lambda1));
        disp("respuesta.lambda2");
        disp(size(respuesta.lambda2));
        plot (OR);
        title("ALEX");

      
        

      end
      
   end
end