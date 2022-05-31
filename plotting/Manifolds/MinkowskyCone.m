function [X,Y,Z] = MinkowskyCone(p0,p1,R0,R1)

    %Vector in direction axis
    v = p1 - p0;
    % find magnitude of vector
    mag = norm(v);
    % unit vector in direction of axis
    v = v / mag;
    disp(v);
    % make some vector not in the same direction as v
    not_v = [1, 1, 0];
    if (v(1) == not_v(1) && v(2) == not_v(2) && v(3) == not_v(3))
        not_v = [0, 1, 0];
    end
    % make vector perpendicular to v
    n1 = cross(v, not_v);
    % print n1,'\t',norm(n1)
    % normalize n1
    n1 =n1/norm(n1);
    disp(n1);
    % make unit vector perpendicular to v and n1
    n2 = cross(v, n1);
    disp(n2);
    % surface ranges over t from 0 to length of axis and 0 to 2*pi
    n = 60;
    t = linspace(0, mag,n);
    disp(t);
    theta = linspace(0, 2 * pi, n);
    disp(theta);
    % use meshgrid to make 2d arrays
    [t, theta] = meshgrid(t, theta);
    disp("---------")
    disp(t)
    R = linspace(R0, R1, n);
    disp("00000R");
    disp(R);
    % generate coordinates for surfac
    X = (p0(1) + v(1) * t + R .*sin(theta) * n1(1) + R .* cos(theta) * n2(1));
    Y = (p0(2) + v(2) * t + R .*sin(theta) * n1(2) + R .* cos(theta) * n2(2));
    Z = (p0(3) + v(3) * t + R .*sin(theta) * n1(3) + R .* cos(theta) * n2(3));
    %ax.plot_surface(X, Y, Z, color=color, linewidth=0, antialiased=False)
    disp(R* sin(theta));
 
end
