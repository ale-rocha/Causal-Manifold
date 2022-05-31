function  plot_serie(serie,sampling_rate,title)
   x = linspace(1,length(serie),length(serie))/sampling_rate;
   plot(x,serie);
   xlabel('Time [s]');
   ylabel('Amplitude')
   shg;

end
