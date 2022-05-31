function [components variances] = mypca(X, m)
  close all

  % We start yby calcing the mean
  % This gives us a 1 x i matrix with the average of all i rows of an image
  meanX = mean(X);

  % Now iterate through X and center the values
  for i = 1:size(X,1)
      for j = 1:size(X,2)
          X(i,j) = X(i,j) - meanX(j);
      end
  end

  % Transpose X to calc C    
  X_T = transpose(X);
  % Use the formula gives to calulate C
  cov = (1/(size(X,1) - 1)) * X_T * X;

  [V, D] = eigs(cov, m);
  % returns diagonal matrix D containing the eigenvalues on the main diagonal,
  % and matrix V whose columns are the corresponding eigenvectors. 
  % eigenvectors and eigenvalues, i.e., the principal components and principal values

  % eigenvectors = V = princ. components
  components = V;

  % eigenvalues = D = princ. values
  % Convert the matrix of principal values returned in 3 into a vector.
  variances = diag(D);
end 