function x = pnorm(frequencie,phase)
   %%Time specifications:
   Fs = 8000;                   % samples per second
   dt = 1/Fs;                   % seconds per sample
   StopTime = 1;                % seconds
   t = (0:dt:StopTime-dt)';     % seconds
   %%Sine wave:
   Fc = frequencie;                      % hertz
   phi=phase;  %phase
   x = sin(2*pi*Fc*t+phi);
   % Plot the signal versus time:
   figure;
   plot(t,x);
   xlabel('time (in seconds)');
   title('Signal versus Time');
   zoom xon;
   return;
end
