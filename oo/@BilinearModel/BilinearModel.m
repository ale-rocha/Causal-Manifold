classdef BilinearModel < matlab.mixin.SetGet
   properties
        Name = "Bilinear model Tack";
        Instrument;
        Timestamps;
        Params;
        RawObservations;
        RawObservationsHbO2; % OxyHb
        RawObservationsHb;   % DeOxy
        Channels;
        Seconds;
        Zones;
        NumberControlChannels = 2;
   end
   methods
      function value = get.NumberControlChannels(obj)
        value = obj.NumberControlChannels;
      end
      function value = get.Channels(obj)
        value = obj.Channels;
      end
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
        obj.Channels =6;
        obj.Zones =2;
        obj.Seconds =round(size(U,2)/freq);

        %% DCM start!
        %% Neurodynamics
        [Z] = Neurodynamics(obj.Params.Neurodynamics.A, obj.Params.Neurodynamics.B, obj.Params.Neurodynamics.C, U, 1/freq);

        %% Hemodynamic  
        [P,Q] = Hemodynamic(Z, U, obj.Params.Hemodynamic.P_SD, obj.Params.Neurodynamics.A,1/freq);
        %[P,Q] = Hemo(Z, U, obj.Params.Hemodynamic.P_SD, obj.Params.Neurodynamics.A,1/freq);

        %% Optic
        %[SMA,M1] = OpticLib( P,Q, U,obj.Params.Neurodynamics.A, obj.Params.Noise.add_noise);
        %obj.RawObservations = [SMA,M1];
        %% Optic master
        [OR,respuesta] = OpticLicMaster(P,Q,obj.Params.Neurodynamics.A); 
        obj.RawObservationsHbO2 = respuesta.lambda1;
        obj.RawObservationsHb = respuesta.lambda2;
        if obj.NumberControlChannels > 0
            control_series = zeros(size(OR,1),obj.NumberControlChannels*2);
            ORnew = ones(size(OR,1),size(OR,2)+obj.NumberControlChannels*2);
            ORnew(:,1:size(OR,2))=OR;
            ORnew(:,size(OR,2)+1:size(OR,2)+obj.NumberControlChannels*2)=control_series;
            obj.RawObservations = ORnew;
        else
             obj.RawObservations = OR;
        end
        %plot(OR(:,1:6))
        %shg;
        %stop;
      end
      
   end
end