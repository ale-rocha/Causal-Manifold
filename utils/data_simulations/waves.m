function x = waves(range_freq,range_phase,sampling_rate,seconds)
   %%Time specifications:
   Fs = sampling_rate;          % samples per second
   dt = 1/Fs;                   % seconds per sample
   StopTime = seconds;          % seconds
   t = (0:dt:StopTime-dt)';     % seconds
   %%Sine wave:
   Fc = frequencie;                      % hertz
   phi=phase;  %phase
   x = sin(2*pi*Fc*t+phi);
   % Plot the signal versus time:
   %figure;
   %plot(t,x);
   %xlabel('time (in seconds)');
   %title('Signal versus Time');
   %zoom xon;
   return;
end
