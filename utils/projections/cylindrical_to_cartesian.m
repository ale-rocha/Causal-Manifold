function [x,y,z] = cylindrical_to_cartesian(points)
  fixed_radius = 1;
  x=[]; y=[]; z=[];
  
  for i = 1:length(points)
      point = points(i);
      phase =  point.Phase;
      freq =  point.Frequency; 
  
      x=[x,fixed_radius*cos(phase)];
      y=[y,fixed_radius*sin(phase)];
      z=[z,freq];
  end
end 