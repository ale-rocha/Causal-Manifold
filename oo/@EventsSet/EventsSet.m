classdef EventsSet < matlab.mixin.SetGet
   properties
      EventsRaw ;
      BilinearModel;
   end
   methods
      function value = get.EventsRaw(obj)
        value = obj.EventsRaw;
      end
      function value = get.BilinearModel(obj)
        value = obj.BilinearModel;
      end   
      function obj = ProyectObservationsToEvents(obj)
          rawObs = obj.BilinearModel.RawObservations;
          temp_events = [];
          %get raw observations
          id_counter = 0;
          %iter along 
              for  chanel = 1:size(rawObs,2)
                  id_counter = id_counter+1;
                  y=rawObs(:,chanel);
                  [S_phase,S_freq,S_time] = STFT_Projection(y, obj.BilinearModel.Instrument.SamplingFrequency);
                  %Create event object
                  for t = 1:size(S_time,2)
                        e = Event();
                        e.Phase = S_phase(t);
                        e.Frequency = S_freq(t);
                        e.Time = S_time(t) ;
                        e.InfoChanel = chanel;
                        temp_events = [temp_events,e];
                  end
              end
          obj.EventsRaw = temp_events;
      end
   end
end