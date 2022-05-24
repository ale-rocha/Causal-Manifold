function  [max_phase, max_freq] = get_max_pf(frequencies,spectre,second,phasetoseconds,tol,display)
   %Regresa la frecuencia dominante y su fase correspondiente
   zero_freq=length(frequencies)/2; 
   
   %Pretratamient frequencies
   frequencies = frequencies(zero_freq:length(frequencies)); %Only positive frequencies
   
   %Pretratamient spectre
   spectre = spectre(:,second);  
   spectre = spectre(zero_freq:length(spectre));
   
   %Pretatamient phase
   phase = angle(spectre);
   
   %Get max values frequency
   spectre(abs(spectre) < tol) = 0;    %Threashold
   spectre = abs(spectre);
   [value,index] = max(spectre);       %Get max value spectre
   max_freq = frequencies(index);      %Correlate with frequency
   max_phase = phase(index);
   
   %Get phase in seconds
   if (phasetoseconds)
       max_phase = ((max_phase*max_freq)/(2*pi));
   end

   disp("Max phase: ");
   disp(max_phase);
  
   disp("Max freq");
   disp(max_freq);
end
