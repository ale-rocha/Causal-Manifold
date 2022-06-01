
function [ldim] = check_shortest_dim(serie)
  %Revisa a lo largo de las dimensiones del array, cual es la dimension
  %de los pasos de tiempo, el criterio es simple, la dimensión de mayor
  %dimension se tomará como los pasos de tiempo de la serie
  [dim1,dim2] = size(serie);
  if (dim1 > dim2)
     ldim =2;
  elseif (dim2 > dim1)
     ldim = 1;
  elseif (dim2 == dim1)
      ldim = dim1;
  end
end