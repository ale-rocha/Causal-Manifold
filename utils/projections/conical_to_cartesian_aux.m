function [x,y,z] = conical_to_cartesian_aux(phase, freq)
      x=cos(phase);
      y=sin(phase);
      z=freq;
end 