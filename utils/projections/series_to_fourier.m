function [phases,frequencies,times] = series_to_fourier(series,sampling_rate)
    phases = []; frequencies = []; times=[];
    sdim = check_dim_shortest_dim(series);
    for index_serie = 1:sdim %Iter each serie
         [S_phase,S_freq,S_time] = STFT_Projection(series(:,index_serie), sampling_rate);
         phases = [phases,S_phase]; 
         frequencies = [frequencies,S_freq]; 
         times=[times, S_time];
    end
end