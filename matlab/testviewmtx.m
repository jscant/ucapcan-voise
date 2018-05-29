function testviewmtx

% T = viewmtx(az,el,phi,xc) returns the perspective transformation matrix using
% xc as the target point within the normalized plot cube (i.e., the camera is
% looking at the point xc). xc is the target point that is the center of the
% view. You specify the point as a three-element vector, xc = [xc,yc,zc], in the
% interval [0,1]. The default value is xc = [0,0,0].

% A four-dimensional homogenous vector is formed by appending a 1 to the
% corresponding three-dimensional vector. For example, [x,y,z,1] is the
% four-dimensional vector corresponding to the three-dimensional point [x,y,z]. 

% Determine the projected two-dimensional vector corresponding to the
% three-dimensional point (0.5,0.0,-3.0) using the default view direction. Note
% that the point is a column vector. 
A = viewmtx(-37.5,30);
x4d = [.5 0 -3 1]';
x2d = A*x4d;
x2d = x2d(1:2)

% These vectors trace the edges of a unit cube: 
x = [0  1  1  0  0  0  1  1  0  0  1  1  1  1  0  0];
y = [0  0  1  1  0  0  0  1  1  0  0  0  1  1  1  1];
z = [0  0  0  0  0  1  1  1  1  1  1  0  0  1  1  0];

% Transform the points in these vectors to the screen, then plot the object.
A = viewmtx(-37.5,30);
[m,n] = size(x);
x4d = [x(:),y(:),z(:),ones(m*n,1)]';
x2d = A*x4d;
x2 = zeros(m,n); y2 = zeros(m,n);
x2(:) = x2d(1,:);
y2(:) = x2d(2,:);
figure

z2 = zeros(m,n);
z2(:) = x2d(3,:)
plot(x2,y2)

pause

% Use a perspective transformation with a 25 degree viewing angle:
A = viewmtx(-37.5,30,25);
x4d = [.5 0 -3 1]';
x2d = A*x4d;
x2d = x2d(1:2)/x2d(4) % Normalize

% Transform the cube vectors to the screen and plot the object:
figure
A = viewmtx(-37.5,30,25);
[m,n] = size(x);
x4d = [x(:),y(:),z(:),ones(m*n,1)]';
x2d = A*x4d;
x2 = zeros(m,n); y2 = zeros(m,n);
x2(:) = x2d(1,:)./x2d(4,:);
y2(:) = x2d(2,:)./x2d(4,:);
plot(x2,y2)


