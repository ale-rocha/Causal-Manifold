function sea = cosine(frequencies, phases)
    sea = [];
    for freq = 1:10
        for phase = 1:20
            %%Time specifications:
            Fs = 8000;                   % samples per second
            dt = 1/Fs;                   % seconds per sample
            StopTime = 1;                % seconds
            t = (0:dt:StopTime-dt)';     % seconds
            %%Sine wave:
            Fc = 5;                      % hertz
            phi=40;  %phase
            x = sin(2*pi*Fc*t+phi);
            % Plot the signal versus time:
            figure;
            plot(t,x);
            xlabel('time (in seconds)');
            title('Signal versus Time');
            zoom xon;
        end
    end
    return;
end
