function [x,y,z] = point_cylindrical_to_cartesian(phase,freq,time)

      x= time*cos(phase);
      y= time*sin(phase);
      z= freq;
end 