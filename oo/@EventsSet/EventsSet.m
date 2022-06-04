classdef EventsSet < matlab.mixin.SetGet
   properties
      EventsRaw ;
      BilinearModel;
      PhaseMin;
      PhaseMax;
      FrequencyMin;
      FrequencyMax;
      TimeMin;
      TimeMax;
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
          %Control dimensions
          max_frequency = 0;
          min_frequency = 1000000;
          max_phase = 0;
          min_phase = 1000000;
          max_time = 0;
          min_time = 7000000;
          %iter along 
              for  chanel = 1:size(rawObs,2)
                  id_counter = id_counter+1;
                  y=rawObs(:,chanel);
                  [S_phase,S_freq,S_time] = STFT_Projection(y, obj.BilinearModel.Instrument.SamplingFrequency);
                  %Create event object
                  for t = 1:size(S_time,2)
                        if S_phase(t) == 2*pi  %Correction phase
                            S_phase(t) = 0;
                        end
                        %Event declaration
                        e = Event();
                        e.Phase = S_phase(t);
                        e.Frequency = S_freq(t);
                        e.Time = S_time(t) ;
                        e.PhaseCos = cos(S_phase(t));
                        e.PhaseSin = sin(S_phase(t));
                        e.InfoChanel = chanel;
                        temp_events = [temp_events,e];

                        
                        if e.Phase > max_phase
                            max_phase = e.Phase;
                        elseif e.Phase < min_phase
                            min_phase = e.Phase;
                        end
                        if e.Frequency > max_frequency
                            max_frequency = e.Frequency;
                        elseif e.Frequency < min_frequency
                            min_frequency = e.Frequency;
                        end
                        if size(S_time,2) > max_time
                            max_time = size(S_time,2);
                        elseif size(S_time,2) < min_time
                            min_time = size(S_time,2);
                        end
     
                  end
                  obj.PhaseMin = min_phase;
                  obj.PhaseMax = max_phase;
                  obj.FrequencyMin = min_frequency;
                  obj.FrequencyMax = max_frequency;
                  obj.TimeMin = min_time;
                  obj.TimeMax = max_time;
                  obj.EventsRaw = temp_events;
              end
        end
   end
end