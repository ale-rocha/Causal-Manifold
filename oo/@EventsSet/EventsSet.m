classdef EventsSet < matlab.mixin.SetGet
   properties
      EventsRaw ;
      NormalizedType; 
      EventsRawNormalized;
      BilinearModel;
      PhaseMin;
      PhaseMax;
      FrequencyMin;
      FrequencyMax;
      TimeMin;
      FrequencySupRange = 50;
      TimeMax;
   end
   methods
   
      function value = get.EventsRaw(obj)
        value = obj.EventsRaw;
      end
      function value = get.FrequencySupRange(obj)
        value = obj.FrequencySupRange;
      end
      function value = get.NormalizedType(obj)
        value = obj.NormalizedType;
      end
      function value = get.EventsRawNormalized(obj)
        value = obj.EventsRawNormalized;
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
                        e.PhaseCos = real(cos(S_phase(t)));
                        e.PhaseSin = real(sin(S_phase(t)));
                        e.InfoChanel = chanel;
                        chanelname = strcat("Ch_",string(e.InfoChanel));
                        timename = strcat("_Time_",string(e.Time));
                        phasename = strcat("_Phase_",string(e.Phase));
                        freqname = strcat("_Freq_",string(e.Frequency));
                        namefile = strcat(chanelname,timename);
                        namefile = strcat(namefile,phasename);
                        namefile = strcat(namefile,freqname);
                        e.PathCones = namefile;
                        
                        if chanel < size(rawObs,2)/2
                            e.InfoMeasure = "Hb";
                        else
                             e.InfoMeasure = "HbO2";
                        end
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
                        if e.Time > max_time
                            max_time = e.Time;
                        elseif e.Time < min_time
                            min_time = e.Time;
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
        % Normalize all events
        temp_events = [];
        for ne = 1:size(obj.EventsRaw,2)
            
            % normalize frequency
            normFreq = obj.EventsRaw(ne).Frequency;
            normFreq = normFreq - obj.FrequencyMin;
            normFreq = normFreq / obj.FrequencySupRange;

            
            %normalize time
            normTime = obj.EventsRaw(ne).Time;
            normTime = normTime - obj.TimeMin;
            normTime = normTime / obj.TimeMax;
            
            
            %normalize cos ans sin phase
            normCos = obj.EventsRaw(ne).PhaseCos;
            normCos = normCos - 0;
            normCos = normCos ./ 2*pi;
            normSin = obj.EventsRaw(ne).PhaseSin;
            normSin = normSin - 0;
            normSin = normSin ./ 2*pi;
            
            %normalize  phase
            normPhase = asin(normSin);
            
            e = Event();
            e.Phase = normPhase;
            e.Frequency = normFreq;
            e.Time = normTime;
            e.PhaseCos = real(normCos);
            e.PhaseSin = real(normSin);
            e.InfoChanel = obj.EventsRaw(ne).InfoChanel;
            e.InfoMeasure = obj.EventsRaw(ne).InfoMeasure;
            e.PathCones = obj.EventsRaw(ne).PathCones;
            temp_events = [temp_events,e];
        end
        obj.EventsRawNormalized = temp_events; %saving
      end
   end
end