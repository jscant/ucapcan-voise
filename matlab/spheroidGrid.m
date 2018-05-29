function [xm,ym,zm,xp,yp,zp,north,south] = spheroidGrid(rotaxis,a,b,xhat,yhat,zhat)

% conversion factors
degPerRad = cspice_dpr;
radPerDeg = cspice_rpd;

e = sqrt(1-b^2/a^2);

north = rotaxis*b;
south = -rotaxis*b;

if 0
% Euler angles of [xhat,yhat,zhat]
% http://mathworld.wolfram.com/EulerAngles.html
% http://en.wikipedia.org/wiki/Rotation_formalisms_in_three_dimensions
% x-convention
alph = atan2(zhat(1),-zhat(2))*degPerRad;
D = [cosd(alph),sind(alph),0;-sind(alph),cosd(alph),0;0,0,1];
beta = acosd(zhat(3));
C = [1,0,0;0,cosd(beta),sind(beta);0,-sind(beta),cosd(beta)];
gamm = atan2(xhat(3), yhat(3));
B = [cosd(gamm),sind(gamm),0;-sind(gamm),cosd(gamm),0;0,0,1];
A = B*C*D;
end

if 1
% Euler angles of [X,Y,Z] where Z is rotaxis, 
% X is in (Z,x)-plane and Y completes the ref frame 
% http://mathworld.wolfram.com/EulerAngles.html
% http://en.wikipedia.org/wiki/Rotation_formalisms_in_three_dimensions
% x-convention
Z = rotaxis;
X = cspice_vhat(-dot(Z,[1;0;0])*Z+[1;0;0]);
Y = cross(Z,X);
A = [X,Y,Z];
end


[r, colat, lon] = cspice_recsph(rotaxis);


[colat*degPerRad, lon*degPerRad]

% colatitude is the complementary angle of the latitude, i.e. the difference
% between 90° and the latitude
colat =  acosd(dot(rotaxis,[0;0;1]))
lat = atan2(dot(rotaxis,[0;0;1]),cspice_vnorm([rotaxis(1);rotaxis(2);0]))*degPerRad
colat = 90-lat

% longitude measured from x axis (0,-1,0) clockwise (0,1,0) counterclockwise
lon = atan2(dot(cspice_vhat([rotaxis(1);rotaxis(2);0]),[0;-1;0]),...
            dot(cspice_vhat([rotaxis(1);rotaxis(2);0]),[1;0;0]))*degPerRad

rotaxis
plot3([0;rotaxis(1)],[0;rotaxis(2)],[0;rotaxis(3)])
axis vis3d
axis equal
az = lon
el = lat
% Azimuth is a polar angle in the x-y plane, with positive angles indicating
% counterclockwise rotation of the viewpoint and measured from the -y axis.
% Elevation is the angle above % (positive angle) or below (negative angle)
% the x-y plane.
view([az,el])
view(rotaxis)
xlabel('x'); ylabel('y'); zlabel('z');
pause

% generate data with 1 deg angle resolution
[x,y,z] = ellipsoid(0,0,0,a,a,b,360);

if 1,
for i=1:length(x(:)),
  pos = A*[x(i);y(i);z(i)];
	x(i) = pos(1); y(i) = pos(2); z(i) = pos(3);
end
%rotaxis = A*rotaxis;
end

is = 1:20:361;
% meridians
xm = x(:,is); ym = y(:,is); zm = z(:,is);
% parallels
xp = x(is,:)'; yp = y(is,:)'; zp = z(is,:)';

clf

if 1
mesh(x(is,is),y(is,is),z(is,is));
alpha(0.5)
else
plot3(xm,ym,zm,'k-',xp,yp,zp,'k-')
end
hold on
plot3([0],[0],[0],'kx-','Markersize',10)
plot3([north(1);south(1)],[north(2);south(2)],[north(3);south(3)],'kx-')
text(north(1),north(2),north(3),'N')
text(south(1),south(2),south(3),'S')
if 0
plot3(a*[0;1],a*[0;0],a*[0;0],'rx-','linewidth',2)
plot3(a*[0;0],a*[0;1],a*[0;0],'gx-','linewidth',2)
plot3(a*[0;0],a*[0;0],a*[0;1],'rx-','linewidth',2)
end
px=a*[0;X(1)]; py=a*[0;X(2)]; pz=a*[0;X(3)];
plot3(px,py,pz,'rx-','linewidth',2)
text(px(2),py(2),pz(2), 'x');
px=a*[0;Y(1)]; py= a*[0;Y(2)]; pz=a*[0;Y(3)];
plot3(px,py,pz,'gx-','linewidth',2)
text(px(2),py(2),pz(2), 'y');
px=a*[0;Z(1)]; py= a*[0;Z(2)]; pz=a*[0;Z(3)];
plot3(px,py,pz,'bx-','linewidth',2)
text(px(2),py(2),pz(2), 'z');
px=a*([0;xhat(1)]+zhat(1)); py=a*([0;xhat(2)]+zhat(2)); pz=a*([0;xhat(3)]+zhat(3));
plot3(px,py,pz,'rx-','linewidth',2)
text(px(2),py(2),pz(2), 'xi');
px=a*([0;yhat(1)]+zhat(1)); py=a*([0;yhat(2)]+zhat(2)); pz=a*([0;yhat(3)]+zhat(3));
plot3(px,py,pz,'gx-','linewidth',2)
text(px(2),py(2),pz(2), 'yi');
px=a*([0;zhat(1)]+zhat(1)); py=a*([0;zhat(2)]+zhat(2)); pz=a*([0;zhat(3)]+zhat(3));
plot3(px,py,pz,'bx-','linewidth',2)
text(px(2),py(2),pz(2), 'zi');
hold off
%view(lon*degPerRad,colat*degPerRad)
xlabel('x'); ylabel('y'); zlabel('z');
pause

[Xm,Ym,Zm] = project(xm,ym,zm,xhat,yhat,zhat);
% Remove hidden point i.e. point back the z=0 plane
Xm(Zm<0) = NaN;
Ym(Zm<0) = NaN;
[Xp,Yp,Zp] = project(xp,yp,zp,xhat,yhat,zhat);
% Remove hidden point i.e. point back the z=0 plane
Xp(Zp<0) = NaN;
Yp(Zp<0) = NaN;

[XN,YN,ZN] = project(north(1),north(2),north(3),xhat,yhat,zhat);
[XS,YS,ZS] = project(south(1),south(2),south(3),xhat,yhat,zhat);

plot(Xm,Ym,'k-');
hold on
plot(Xp,Yp,'k-');
plot([XN,XS],[YN,YS],'bx')
text(XN,YN,'N')
text(XS,YS,'S')
hold off
pause

function [X,Y,Z] = project(x,y,z,xhat,yhat,zhat)

X = zeros(size(x));
Y = zeros(size(x));
Z = zeros(size(x));

for i=1:length(x(:)),
  % projection onto the image plane
  posn = [x(i);y(i);z(i)];
  X(i) = dot(posn,xhat); 
  Y(i) = dot(posn,yhat);
  % positive means nearer to Earth than planet centre
  Z(i) = dot(posn,zhat);
end
