function [x,y,z] = conical_to_cartesian(points)
  fixed_radius = 1;
  x=[]; y=[]; z=[];
  
  for i = 1:length(points)
      point = points(i);
      phase =  point.Phase;
      freq =  point.Frequency; 
    
      x=[x,freq*cos(phase)];
      y=[y,freq*sin(phase)];
      z=[z,freq];
      disp("888888888888888888888888888888888")
      disp(z)
  end
end 
