
 function [Y, e] = cdmscaling (D) 
  % Check for input
  if (nargin == 0)
    print_usage ();
  end

  % Convert vector input to matrix
   if isvector (D)
     D = squareform (D);
   end
  
  
  M = (D(1, :) .^ 2 +  D(:, 1) .^ 2 - D .^ 2) / 2;
 
  [v e] = eig(M);
  
  e = diag(e);
  pe = (e > 0); %positive eigenvalues
  
  Y = v(:, pe) * diag(sqrt(e(pe)));
 
  
  n = size (D,1);
  % Check for valid format (see help above); If similarity matrix, convert
  if (~all (D >= 0))
    print_usage ();
  elseif (trace (D) ~= 0)
      if ((~all (diag (D) == 1)) || (~all (D <= 1)))
        print_usage ();
      end
      D = sqrt (ones (n,n) - D);
  end

  % Build centering matrix, perform double centering, extract eigenpairs
  J = eye (n) - ones (n,n) / n;
  B = -1 / 2 * J * (D .^ 2) * J;
  [Q, e] = eig (B);
  e = diag (e);
  etmp = e;

  % Remove complex eigenpairs (only possible due to machine approximation)
  if (~isreal (etmp))
    for i = 1 : size (etmp,1)
      cmp(i) = (isreal (etmp(i)));
    end
    etmp = etmp(cmp);
    Q = Q(:,cmp);
    end

  % Order eigenpairs
  [etmp, ord] = sort (etmp, 'descend');
  Q = Q(:,ord);

  % Remove negative eigenpairs
  cmp = (etmp > 0);
  etmp = etmp(cmp);
  Q = Q(:,cmp);

  % Build output matrix Y
  Y = Q * diag (sqrt (etmp));

      end
 
