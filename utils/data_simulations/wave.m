function [t,x] = wave(frequencie,phase,seconds,sampling_rate)
   %%Time specifications:
   dt = 1/sampling_rate;                 % seconds per sample
   StopTime = seconds;                   % seconds
   t = (0:dt:StopTime-dt)';              % seconds
   Fc = frequencie;                      % hertz
   %%Sine wave:
   x = cos(2*pi*Fc*t+phase);
   return;
end
