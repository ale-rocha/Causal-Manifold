function [e,info]=EMDOverCylinder(X1,X2)
%Calculates the EMD distance between two distributions in a cylindrical space
%
%
% [e,info]=EMDOverCylinder(X1,X2) - Calculates the EMD distance
%   between two distributions in a cylindrical space (using the
%   geodesic distance over the cylinder).
%
%   The weights for the EMD will be estimated from the probabilities of the
%observations of the distributions. The transport costs (ground distances)
%will be estimated as the geodesic distance over the cylinder between
%the observations.
%
%
%% Remarks
%
% Note that both distributions are expected to lay on the same cylinder
%space (i.e. the radius has to be constant for both).
%
%
% In the particular case when, this function is used for distributions
%representing Fourier transforms of signals, the cylindrical coordinates
%should be organised as:
%
%   <height [A.U.], angle [rads], radius [A.U.], nObservations> =
%                               <f [Hz], theta [rads], r, Amplitudes>
%
%   and radius can be arbitrarily set to r=1.
%
%
%% Parameters
%
% X1,X2 - Two distributions spread over a cylinder of radius r.
%   The distributions are expected to be a mx3 matrix:
%
%   <height [A.U.], angle [rads], radius [A.U.], nObervations>
%
%   with m (rows) being the locations where the distributions have
%   been observed (e.g. bins centroids in a classical histogram).
%   Note the polar coordinates.
%
%% Output
%
% e - The EMD distance between distributions
% info - A struct with the following information
%   .weights1 - The weigths of the first distribution
%   .weights2 - The weigths of the second distribution
%   .costs - The transport costs between pairs of locations were the
%       distributions have been observed. i.e. Geodesic over the cylinder.
%   .flows - The flows of weigths between locations were the
%       distributions have been observed.
%
%
%
%
% Copyright 2018
% @date: 21-Feb-2018
% @author Felipe Orihuela-Espina
% @modified: 21-Feb-2018
% 
% See also pdist, ic_pdist, Floyd, pruneDistances, geodesic
%





%% Log
%
% 21-Feb-2018 (FOE): Function created
%



idx1= [1:size(X1,1)];


 
COL_HEIGHT = 1; %Frequency for the case of Fourier transformed signals
COL_ANGLE = 2; %Phase for the case of Fourier transformed signals
COL_RADIUS = 3;
COL_NOBSERVATIONS = 4; %Amplitudes for the case of Fourier transformed signals


idx1= [1:size(X1,1)];
idx2= [idx1(end)+1:idx1(end)+size(X2,1)];


%Temporally join all points to calculate pairwise ground distances
tmpX=[X1(:,[COL_HEIGHT COL_ANGLE COL_RADIUS]); ...
      X2(:,[COL_HEIGHT COL_ANGLE COL_RADIUS])];
D=squareform(pdist(tmpX,@geodesicOverCylinder));


%Now set things for the EMD distance.
%   Weigths in this case are the amplitudes
%   Ground distance (costs) are in this case the geodesic distances
info.weights1=X1(:,COL_NOBSERVATIONS)';
info.weights2=X2(:,COL_NOBSERVATIONS)';
info.costs=D(idx1,idx2); %Filter the submatrix of distances
                         %between the points of distribution 1
                         %vs the points of distributions 2


% nPoints =5;
% weights1=rand(1,5);
% weights2=rand(1,5);
% costs = rand(5);


%Finally calculate EMD distances between the distributions
[e,info.flows]=emd_mex(info.weights1,info.weights2,info.costs);




end

