%%
function [matrix_distances] = DistancesCubinder(S1_phase,S1_freq,S1_time, S2_phase,S2_freq,S2_time)
   %Compute distances
   matrix_distances = zeros(size(S1_phase,2),size(S1_phase,2));
   for index1 = 1:size(S1_phase,2)
       for index2 = 1:size(S1_phase,2)
           if (abs(S1_phase(index1) -S2_phase(index2))<=pi)
                  phase_diff = abs(power(((S1_phase(index1))-(S2_phase(index2))),1));
           else
                  %phase_temp = power((point_phase(p1)-point_phase(p2)),2);
                  phase_diff = abs(power((2*pi)-abs((S1_phase(index1))-(S2_phase(index2))),1));
           end
           freq_diff = S1_freq(index1) - S2_freq(index2);
           time_diff = S1_time(index1) - S2_time(index2);
           total_diff = abs(phase_diff) + abs(freq_diff) - abs(time_diff);
           matrix_distances(index1,index2) = total_diff;
       end
   end
   
end

