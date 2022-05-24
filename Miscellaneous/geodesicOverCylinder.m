function  [D]=geodesicOverCylinder(p1,P2,options)
%Calculate the (cylindric) geodesic over the cylinder between points.
%
% [D]=geodesicOverCylinder(p1,P2) - Calculate the geodesic over the
%   cylinder between p1 and all points in P2.
%
% [D]=geodesicOverCylinder(p1,P2,options) - Calculate the geodesic over the
%   cylinder between p1 and all points in P2 with the given options
%
%
% Points are expected in cylindrical coordinates;
%   <linear frequency [Hz], phase [rads], radius [A.U.]>
%
% Since points are expected to lay on a cylinder, the radius must coincide
% for all points.
%
%
%% Remarks
%
% The signature of the function (1-vs-m points) is demanded so that
%it can be later called by pdist when used with a function handle.
%
%
%Two algorithms are provided:
% Algorithm 1 - Downloaded from: https://la.mathworks.com/matlabcentral/fileexchange/6522-geodesic
% Algorithm 2 - Approximation by short hops (FOE); less efficient, but
%   easier to "understand" if you want. This is the dafault.
%
%Both algorithms generate however intermediate points, since applying
%the explicit formula would require solving the integral.
%
%
% Note that generally, two curves can be obtained: one is the
%correct geodesic (the one calculated here) and the other is the
%conjugate geodesic (i.e. travelling in the opposite direction)
%which is longer than the correct one. If you also want this
%have a look at https://la.mathworks.com/matlabcentral/fileexchange/6522-geodesic
%
%
%
%% Parameters
%
% p1- A single point. A row vector representing a point over a cylinder
%       expressed in cylindrical coordinates <frequency, phase, radius>
% P2 - A set of points. A matrix of m row vectors representing m point 
%       over a cylinder expressed in cylindrical coordinates
%       <frequency, phase, radius>
%
% options - A struct of options with the folloowing optional fields:
%   .algo - The algorithm to be used to calculate the geodesic (see
%       remarks above). Possible values are:
%           1 - Algorithm 1 - Downloaded from: https://la.mathworks.com/matlabcentral/fileexchange/6522-geodesic
%           2 - Algorithm 2 - Approximation by short hops (FOE); less efficient, but
%                   easier to "understand" if you want. This is the default.
%   .fontSize - Font size of the rendering plot (see option .render)
%   .nSteps - Number of intermediate points in the geodesic.
%       Both algorithms generate however intermediate points, since applying
%       the explicit formula would require solving the integral.
%   .render - Plot a figure to show the intermediate points and geodesic
%       curve in the cylinder. By default is set to false.
%       IMPORTANT: DO NOT USE THIS OPTION IF YOU HAVE A LARGE NUMBER
%           OF POINTS IN P2
%
%% Output
%
% D - A m-by-1 vector of distances, whose j-th element is the distance
%   between the p1 and P2(j,:)
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






%Two algorithms are provided:
% Algorithm 1 - Downloaded from: https://la.mathworks.com/matlabcentral/fileexchange/6522-geodesic
% Algorithm 2 - Approximation by short hops (FOE)
%Both algorithms generate however intermediate points, since applying
%the explicit formula would require solving the integral
opt.algo = 2;
opt.fontSize = 12;
opt.render = false;
opt.nSteps = 500; %Number of intermediate points
if exist('options','var')
    if isfield(options,'algo')
        opt.algo = options.algo;
    end
    if isfield(options,'fontSize')
        opt.fontSize = options.fontSize;
    end
    if isfield(options,'render')
        opt.render = options.render;
    end
    if isfield(options,'nSteps')
        opt.nSteps = options.nSteps;
    end
end

    %Check that both are in a cylinder of the same radius;
    assert(all(p1(3)==P2(:,3)),...
        'Points are not in a cylinder of the same radius');
    %since all point lay in a cylinder of the same radius, then I can used
    %the radius of p1.
    r = p1(3);

%     %%This is only necessary if you try to used to explicit formula
%     %Here t is not time, but the parameterization of the curve.
%     t1=0;
%     t2=1;
%     dt = t2-t1;
    

    
    for jj=1:size(P2,1)
        %%%Note that applying the explicit formula would require solving the integral
        %D(jj) = sqrt( ((p2(3)-p1(3))/dt)^2 + r^2*((p2(2)-p1(2))/dt)^2 + ((p2(1)-p1(1))/dt)^2 ) *dt ;
        
        %[z - frequency,
        % theta - phase,
        % r - radius]

        %Set the starting and ending points
            %In principle, the geodesic is calculated always
            %"counter-clockwise", but the true geodesic is the one which
            %takes the shortest path i.e. the one taking the smaller angle
        theta1= p1(2);  z1= p1(1);
        theta2= P2(jj,2); z2= P2(jj,1);
        if (pi > theta2-theta1)
            theta1= P2(jj,2); z1= P2(jj,1);
            theta2= p1(2); z2= p1(1);
        end
        
        
        % Parametric expression of Geodesic curve (i.e. intermediate
        % points)
        u = linspace(theta1,theta2,opt.nSteps);
        x = r*cos(u); y = r*sin(u);
        z = ((z2-z1)/(theta2-theta1))*u + (z1*theta2-z2*theta1)/(theta2-theta1);
        
        %If the points have
        %the same phase regardless of the frequency (including
        %the particular case when the point are matched), then
        %the differential terms of z become NaN. Simply set to
        %equally sized steps between z2 and z1
        if (any(isnan(z)))
            t=linspace(0,1,opt.nSteps);
            tmpz = z1+(z2-z1)*t;
            z(isnan(z))= tmpz(isnan(z));
        end
        %[x' y' z']
        
        switch (opt.algo)
            case 1 %"Symbolic" if you want
                D(jj) = sqrt(r^2*(theta2-theta1)^2+(z2-z1)^2);
                
            case 2 %Short hops
        
                %Approximate by short euclidean hops
                sqrddiffx = (x(2:end)-x(1:end-1)).^2;
                sqrddiffy = (y(2:end)-y(1:end-1)).^2;
                sqrddiffz = (z(2:end)-z(1:end-1)).^2;
                tmpdiff=(sqrddiffx+sqrddiffy+sqrddiffz)';
                tmpEuc=sqrt(sum(tmpdiff,2));
                D(jj)=sum(tmpEuc);
            otherwise
                error('Unexpected algorithm for calculating the geodesic');
        end
        
        
        if (opt.render)
            figure,hold on,
            [X,Y,Z] = cylinder(r,100); %For reference only
            Z=Z*ceil(max(z2,z1)); %Scale up
            surf(X,Y,Z);
            h=plot3(x,y,z,'r.');
            box on, grid on;
            legend(h,'Geodesic','Location','NorthEast');
            
            s1=['p1 [f,\theta,r]=<',num2str(p1(1)),',',num2str(p1(2)),',',num2str(p1(3)),'>'];
            p2=P2(jj,:);
            s2=['p2 [f,\theta,r]=<',num2str(p2(1)),',',num2str(p2(2)),',',num2str(p2(3)),'>'];
            title(['Geodesic over cylinder; \newline',...
                    s1,';\newline',s2,';\newline',...
                    'd_{geo}=',num2str(D(jj))],...
                    'FontSize',opt.fontSize);
            xlabel('X','FontSize',opt.fontSize);
            ylabel('Y','FontSize',opt.fontSize);
            zlabel('Z','FontSize',opt.fontSize);
            view(3);
        end
        
        
    end
    
    
end