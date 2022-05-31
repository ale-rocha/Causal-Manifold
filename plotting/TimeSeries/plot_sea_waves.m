function  plot_sea_waves(serie,sampling_rate)
   x = linspace(1,lenght(serie),1)/sampling_rate;
   plot(x,serie);
   shg;

end
