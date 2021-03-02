function x = MatrixDistances(cloud,norm)

  %Prepare data
  frequencies_cloud = [];
  phases_cloud = [];
  
  %Extract phases and frequencies from objects
  points = get(cloud,"Points");
  for p = 1:length(points)
      point = points(p);
      frequencies_cloud = [frequencies_cloud,get(point,"Frequency")];
      phases_cloud = [phases_cloud,get(point,"Phases")]; 
  end
  
  %Calculate distances
  if (norm == "pnorm1")
      cloud.DistancesPNorm1 = pnorm(frequencies_cloud,phases_cloud,1);
  end
  
end
