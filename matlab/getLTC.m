function [ll,ld,tl,td,cusp]=getLTC(r,e,obs,sun)
% function [ll,ld,tl,td,cusp]=getLTC(r,e,obs,sun)
% 
% r equatorial radius
% e excentricity
% obs observer's latitude and longitude in the observed planet's frame
% sun sun's latitude and longitude in the observed planet's frame

%
% $Id: getLTC.m,v 1.3 2018/05/29 13:45:13 patrick Exp $
%
% Copyright (c) 2010
% Patrick Guio <p.guio@ucl.ac.uk>
%
% All Rights Reserved.
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 2.  of the License, or (at your
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
% Public License for more details.
%

% [0,2\pi] angular grid with one degree resolution
theta = linspace(0,2*pi,361);

% deg into rad
olat = obs.lat*pi/180;
olon = obs.lon*pi/180;
slat = sun.lat*pi/180;
slon = sun.lon*pi/180;

% longitude difference
dlon = slon-olon;
dlon = -dlon;

% sky frame
xhato = [0;1;0];
yhato = [sin(olat);0;cos(olat)];
%zhato = cross(xhato, yhato);
zhato = [cos(olat);0;-sin(olat)];

if 0
% "sky" frame in direction to the sun
xhats = [-sin(dlon);cos(dlon);0];
yhats = [cos(dlon)*sin(slat);sin(dlon)*sin(slat);cos(slat)];
%zhats = cross(xhats, yhats);
zhats = [cos(dlon)*cos(slat);sin(dlon)*cos(slat);-sin(slat)];
else
xhats = [sin(dlon);cos(dlon);0];
yhats = [cos(dlon)*sin(slat);-sin(dlon)*sin(slat);cos(slat)];
%zhats = cross(xhats, yhats);
zhats = [cos(dlon)*cos(slat);-sin(dlon)*cos(slat);-sin(slat)];
end

% 
sdir = zhats-dot(zhats,zhato)*zhato;
%[dot(sdir,xhato);dot(sdir,yhato);dot(sdir,zhato)]
xsundir = [0;dot(sdir,xhato)];
ysundir = [0;dot(sdir,yhato)];


if 0
p = [0;0;0];
px = r*([0;xhato(1)]+p(1)); py = r*([0;xhato(2)]+p(2)); pz = r*([0;xhato(3)]+p(3));
plot3(px,py,pz,'rx-','linewidth',2)
text(px(2),py(2),pz(2), 'x_o');
hold on
px = r*([0;yhato(1)]+p(1)); py = r*([0;yhato(2)]+p(2)); pz = r*([0;yhato(3)]+p(3));
plot3(px,py,pz,'gx-','linewidth',2)
text(px(2),py(2),pz(2), 'y_o');
px = r*([0;zhato(1)]+p(1)); py = r*([0;zhato(2)]+p(2)); pz = r*([0;zhato(3)]+p(3));
plot3(px,py,pz,'bx-','linewidth',2)
text(px(2),py(2),pz(2), 'z_o');

p = [0;0;0];
px = r*([0;xhats(1)]+p(1)); py = r*([0;xhats(2)]+p(2)); pz = r*([0;xhats(3)]+p(3));
plot3(px,py,pz,'rx-','linewidth',2)
text(px(2),py(2),pz(2), 'x_s');
px = r*([0;yhats(1)]+p(1)); py = r*([0;yhats(2)]+p(2)); pz = r*([0;yhats(3)]+p(3));
plot3(px,py,pz,'gx-','linewidth',2)
text(px(2),py(2),pz(2), 'y_s');
px = r*([0;zhats(1)]+p(1)); py = r*([0;zhats(2)]+p(2)); pz = r*([0;zhats(3)]+p(3));
plot3(px,py,pz,'bx-','linewidth',2)
text(px(2),py(2),pz(2), 'z_s');
hold off
xlabel('x'),ylabel('y'),zlabel('z')
pause
end


if 0
% disk of the planet with rotation axis vertical
xp = r*cos(theta);
yp = r*sqrt(1-e^2)*sin(theta);
end

% excentricity of the limb
eL = eLimb(e,olat);
% limb in its own plane
xl0 = r*cos(theta);
yl0 = r*sqrt(1-eL^2)*sin(theta);

% limb projected onto the sky-plane (perpendicular to the
% the direction of the observer), the projected rotation axis is vertical
% and xl is in the equatorial plane (Eq A3)
xl = r*cos(theta);
yl = r*sqrt(1-e^2*cos(olat)^2)*sin(theta);

% coordinates of the vector normal to the limb (Eqs. A1 and A2)
nLnorm  = sqrt((1-e^2)^2*cos(olat)^2+sin(olat)^2);
csnllat = (1-e^2)*cos(olat)/nLnorm;
snnllat = sin(olat)/nLnorm;

%180/pi*acos(csnllat)
%180/pi*asin(snnllat)

if 0
% algebraic distance between a point of the limb's projection onto the sky-plane
% Eq A19
DL = cos(slat)*sin(dlon)*xl+...
    (-cos(slat)*cos(dlon)*sin(olat)+sin(slat)/(1-e^2)*cos(olat))*yl;

else
% normal to the spheroid surface for the limb point
% ns = (-a/b yl0 snnllat, b/a xl0, a/b yl0 csnllat)
% ns = (-a/b yl0 sin(olt), b/a xl0, a/b yl0 cos(olat))
% direction to the sun
% dirsun (cos(slat)cos(dlon),-cos(slat)sin(dlon),-sin(slat))
% ns.dirsun > 0 in the light
% ns.dirsun < 0 in the shade
% ns.dirsun == 0 cusp
c = cos(olat); s = sin(olat); ee = e*cos(olat); X = xl; Y = yl;
%c = csnllat; s = snnllat; ee = eL; X = xl0; Y = yl0;
dirsun = [cos(slat)*cos(dlon);-cos(slat)*sin(dlon);sin(slat)];
DL = -1/sqrt(1-ee^2)*Y*s*cos(slat)*cos(dlon)-...
     sqrt(1-e^2)*X*cos(slat)*sin(dlon)-...
		 1/sqrt(1-ee^2)*Y*c*sin(slat);
end
DL = dist(olat,slat,dlon,xl,yl);
% limb in the light
xll = xl; xll(DL<0) = NaN;
yll = yl; yll(DL<0) = NaN;
% limb in the dark
xld = xl; xld(DL>0) = NaN;
yld = yl; yld(DL>0) = NaN;

% embed into cells
ll = {xll(:)',yll(:)'};
ld = {xld(:)',yld(:)'};

% terminator as seen from the sun 
xt0 = r*cos(theta);
yt0 = r*sqrt(1-e^2*cos(slat)^2)*sin(theta);

% Eccentricity of the terminator
eT = eLimb(e,slat);
% terminator in its own plane
%xt0 = r*cos(theta);
%yt0 = r*sqrt(1-eT^2)*sin(theta);

% coordinates of the vector normal to the terminator (Eqs. A4 and A5)
nTnorm  = sqrt((1-e^2)^2*cos(slat)^2+sin(slat)^2);
csntlat = (1-e^2)*cos(slat)/nTnorm;
snntlat = sin(slat)/nTnorm;

% Terms from Eqs A14-A17 i.e. 
a = cos(dlon);
b = -snntlat*sin(dlon);
c = sin(dlon)*sin(olat);
d = snntlat*cos(dlon)*sin(olat)+csntlat*cos(olat);
% matrix to transform (x,y) from the terminator plane to the sky-plane
A = [a, b; c, d];

% vector for equatorial axis 
xis = [0 A(1,1)];
yis = [0 A(2,1)];
% vector for polar axis
xjs = [0 A(1,2)];
yjs = [0 A(2,2)];

% rotated ellipse 
xt = A(1,1)*xt0+A(1,2)*yt0;
yt = A(2,1)*xt0+A(2,2)*yt0;


% direction perpendicular to both the observer and the perpendicular to the
% therminator Eqs. A9 and A10
u = cos(slat)*cos(dlon)*sin(olat)-sin(slat)*cos(olat);
v = cos(slat)*sin(dlon);
%atan2(v,u)*180/pi

%u = -sin(olat)*cos(dlon)*cos(slat)+cos(olat)*sin(slat);
%v = sin(dlon)*cos(slat);
%atan2(v,u)*180/pi

% cusp line
cl3d = cross(zhato,zhats);
cl3d = [ sin(olat)*sin(dlon)*cos(slat);...
        -sin(olat)*cos(dlon)*cos(slat)+cos(olat)*sin(slat);...
				 cos(olat)*sin(dlon)*cos(slat)];
%[dot(cl3d,xhato);dot(cl3d,yhato);dot(cl3d,zhato)]
%[u;v]


% scalars Eq A11
t1 = sqrt(r^2*(1-e^2*cos(olat)^2)/(u^2*(1-e^2*cos(olat)^2)+v^2));

% cusp points 
xc = u*[t1;-t1];
yc = v*[t1;-t1];
% embed in cells
cusp = {xc(:)',yc(:)'};


% there is something wrong here
if 1,
AA = 1/r^2/(a*d-b*c)^2*(d^2+c^2/(1-eT^2));
BB = 1/r^2/(a*d-b*c)^2*(b^2+a^2/(1-eT^2));
CC = -2/r^2/(a*d-b*c)^2*(b*d+a*c/(1-eT^2));
[xta,yta,aa,majAxis,bb,minAxis] = getEllipseAxes(AA,BB,CC);
x1 = majAxis(1)*[-aa;aa];
y1 = majAxis(2)*[-aa;aa];
x2 = minAxis(1)*[-bb;bb];
y2 = minAxis(2)*[-bb;bb];
fprintf(1,'***    1 points x=%f,%f, y=%f,%f\n',x1,y1);
fprintf(1,'***    2 points x=%f,%f, y=%f,%f\n',x2,y2);
clf
plot(xt,yt,xta,yta)
pause
end

% scalars Eq 12
t2 = sqrt(r^2*(1-eT^2)*(a*d-b*c)^2/((d*v+b*u)^2*(1-eT^2)+(c*v+a*u)^2));

% direction orthogonal to cusp points direction
x2 = -v*[t2;-t2];
y2 = u*[t2;-t2];

if 0
x2 = minAxis(1)*[-bb;bb];
y2 = minAxis(2)*[-bb;bb];
end

% tilt, semi-major and semi-minor axes of the ellispe formed 
% by the sky projection of the terminator Eqs. A6, A7 and A8
thetaT = atan2(v,u);
aT = sqrt(u^2+v^2)*t1;
bT = sqrt(u^2+v^2)*t2;
fprintf(1,'aT=%.2f bT=%.2f thetaT=%.0f\n', aT, bT, 180/pi*thetaT);

% rotation matrix of the tilt angle \theta_T
rot = [cos(thetaT), sin(thetaT); -sin(thetaT), cos(thetaT)];

if 0
% rotated ellipse representing the terminator
t = theta;
xt = aT*cos(t)*rot(1,1)+bT*sin(t)*rot(1,2);
yt = aT*cos(t)*rot(2,1)+bT*sin(t)*rot(2,2);
end

% algebraic distance between a point of the terminator's projection onto the
% sky-plane Eq A18
DT = csntlat*sin(dlon)*xt+(-csntlat*cos(dlon)*sin(olat)+snntlat*cos(olat))*yt;
DT = dist(olat,slat,dlon,xt,yt);

clf
plot(theta,DL,theta,DT);
xlabel('theta'), legend('DL','DT');
pause

% visible terminator
xtl = xt; xtl(DT<0) = NaN;
ytl = yt; ytl(DT<0) = NaN;
% hidden terminator
xtd = xt; xtd(DT>0) = NaN;
ytd = yt; ytd(DT>0) = NaN;
% embed into cells
tl = {xtl(:)',ytl(:)'};
td = {xtd(:)',ytd(:)'};

if 0
% polar points of terminator = cusp
t=pi/2;
xt = aT*cos(t)*rot(1,1)+bT*sin(t)*rot(1,2);
yt = aT*cos(t)*rot(2,1)+bT*sin(t)*rot(2,2);
DT = csntlat*sin(dlon)*xt+(-csntlat*cos(dlon)*sin(olat)+snntlat*cos(olat))*yt;
DT = dist(olat,slat,dlon,xt,yt);
end

% algebraic distance of cusp points with limb formula Eq. A19
% should be zero
DLC1 = cos(slat)*sin(dlon)*xc(1)+...
    (-cos(slat)*cos(dlon)*sin(olat)+sin(slat)*cos(olat)/(1-e^2))*yc(1);
DLC2 = cos(slat)*sin(dlon)*xc(2)+...
    (-cos(slat)*cos(dlon)*sin(olat)+sin(slat)*cos(olat)/(1-e^2))*yc(2);

% algebraic distance of cusp points with terminator formula Eq. A18
% should be zero
DTC1 = csntlat*sin(dlon)*xc(1)+...
    (-csntlat*cos(dlon)*sin(olat)+snntlat*cos(olat))*yc(1);
DTC2 = csntlat*sin(dlon)*xc(2)+...
    (-csntlat*cos(dlon)*sin(olat)+snntlat*cos(olat))*yc(2);

DLC1 = dist(olat,slat,dlon,xc(1),yc(1));
DLC2 = dist(olat,slat,dlon,xc(2),yc(2));
DTC1 = dist(olat,slat,dlon,x1(1),y1(1));
DTC2 = dist(olat,slat,dlon,x1(2),y1(2));

fprintf(1,'DLC1=%.2g DLC2=%.2g DTC1=%.2g DTC2=%.2g\n', DLC1, DLC2, DTC1, DTC2);

if 0
if DT>0,
t = linspace(0,pi,100);
xtl = aT*cos(t)*rot(1,1)+bT*sin(t)*rot(1,2);
ytl = aT*cos(t)*rot(2,1)+bT*sin(t)*rot(2,2);
t = linspace(-pi,0,100);
xtd = aT*cos(t)*rot(1,1)+bT*sin(t)*rot(1,2);
ytd = aT*cos(t)*rot(2,1)+bT*sin(t)*rot(2,2);
else
t = linspace(-pi,0,100);
xtl = aT*cos(t)*rot(1,1)+bT*sin(t)*rot(1,2);
ytl = aT*cos(t)*rot(2,1)+bT*sin(t)*rot(2,2);
t = linspace(0,pi,100);
xtd = aT*cos(t)*rot(1,1)+bT*sin(t)*rot(1,2);
ytd = aT*cos(t)*rot(2,1)+bT*sin(t)*rot(2,2);
end
end

%hf = figure;
if 0
subplot(211),
plot(xc,yc,'o',xll,yll,'-',xld,yld,'--',x2,y2,'-o',xis,yis,xjs,yjs);
axis equal
subplot(212),
plot(xc,yc,'o',xtl,ytl,'-',xtd,ytd,'--',x2,y2,'-o',xis,yis,xjs,yjs);
axis equal
else
plot(ll{:},'-',ld{:},'--',tl{:},'-',td{:},'--',cusp{:},x2,y2,'-o');%,xis,yis,xjs,yjs);
[legh,objh,outh,outm] = legend('ll','ld','tl','td','c','c2');%,'is','js');
if 0
plot(ll{:},'o-',ld{:},'o--',cusp{:},x2,y2,'-o');%,xis,yis,xjs,yjs);
[legh,objh,outh,outm] = legend('ll','ld','c','c2');%,'is','js');
end
set(objh(1),'fontsize',9);
axis equal
hold on
%plot(xsundir,ysundir)
hold off
xlabel('x'), ylabel('y')
xlim = get(gca,'xlim');
ylim = get(gca,'ylim');
end
pause
%close(hf) 

if 0
plot(xl,yl,xtl,ytl,'-',...
     xtd,ytd,'--',xc,yc,'-o',x2,y2,'-o',xis,yis,xjs,yjs);

[legh,objh,outh,outm] = legend('limb','tl','td','c','c2','is','js');
set(objh(1),'fontsize',9);

axis equal

title(sprintf('\\beta_{obs}=%.1f \\beta_{sun}=%.1f \\Delta\\lambda=%.1f',...
      olat*180/pi, slat*180/pi, dlon*180/pi));
end

pause

% generate ellipsoid data with 1 deg angle resolution
[x,y,z] = ellipsoid(0,0,0,r,r,r*sqrt(1-e^2),360);
% subsampling
is = 1:20:361;
% meridians
xm = x(:,is); ym = y(:,is); zm = z(:,is);
% parallels
xp = x(is,:)'; yp = y(is,:)'; zp = z(is,:)';

pause
%figure

mesh(x(is,is),y(is,is),z(is,is))
alpha(0.5)
hold on

p = [1;0;0];
%p = [0;0;0];
px = r*([0;xhato(1)]+p(1)); py = r*([0;xhato(2)]+p(2)); pz = r*([0;xhato(3)]+p(3));
plot3(px,py,pz,'rx-','linewidth',2)
text(px(2),py(2),pz(2), 'x_o');
px = r*([0;yhato(1)]+p(1)); py = r*([0;yhato(2)]+p(2)); pz = r*([0;yhato(3)]+p(3));
plot3(px,py,pz,'gx-','linewidth',2)
text(px(2),py(2),pz(2), 'y_o');
px = r*([0;zhato(1)]+p(1)); py = r*([0;zhato(2)]+p(2)); pz = r*([0;zhato(3)]+p(3));
plot3(px,py,pz,'bx-','linewidth',2)
text(px(2),py(2),pz(2), 'z_o');

%p = [cos(dlon);-sin(dlon);0];
p = [0;0;0];
px = r*([0;xhats(1)]+p(1)); py = r*([0;xhats(2)]+p(2)); pz = r*([0;xhats(3)]+p(3));
plot3(px,py,pz,'rx-','linewidth',2)
text(px(2),py(2),pz(2), 'x_s');
px = r*([0;yhats(1)]+p(1)); py = r*([0;yhats(2)]+p(2)); pz = r*([0;yhats(3)]+p(3));
plot3(px,py,pz,'gx-','linewidth',2)
text(px(2),py(2),pz(2), 'y_s');
px = r*([0;zhats(1)]+p(1)); py = r*([0;zhats(2)]+p(2)); pz = r*([0;zhats(3)]+p(3));
plot3(px,py,pz,'bx-','linewidth',2)
text(px(2),py(2),pz(2), 'z_s');

% limb
xl3d = xl*xhato(1) + yl*yhato(1);
yl3d = xl*xhato(2) + yl*yhato(2); 
zl3d = xl*xhato(3) + yl*yhato(3);
plot3(xl3d,yl3d,zl3d,'kx-','linewidth',2)

% terminator
xt3d = xt0*xhats(1) + yt0*yhats(1);
yt3d = xt0*xhats(2) + yt0*yhats(2);
zt3d = xt0*xhats(3) + yt0*yhats(3);
%plot3(xt3d,yt3d,zt3d,'cx-','linewidth',2)

% cusp points
xc3d1 = xc*xhato(1) + yc*yhato(1);
yc3d1 = xc*xhato(2) + yc*yhato(2);
zc3d1 = xc*xhato(3) + yc*yhato(3);
%[xc3d1(1),yc3d1(1),zc3d1(1)]
plot3(xc3d1,yc3d1,zc3d1,'mo-','linewidth',2,'markersize',10)

plot3([0;dirsun(1)],[0;dirsun(2)],[0;dirsun(3)],'r','linewidth',2)
if 0
xc3d2 = xc*xhats(1) + yc*yhats(1);
yc3d2 = xc*xhats(2) + yc*yhats(2);
zc3d2 = xc*xhats(3) + yc*yhats(3);
%[xc3d2(1),yc3d2(1),zc3d2(1)]
plot3(xc3d2,yc3d2,zc3d2,'yd-','linewidth',2)
end

axis equal
axis vis3d
xlabel('x'),ylabel('y'),zlabel('z')
%set(gca,'ylim',xlim);
%set(gca,'zlim',ylim);
hold off

% view along the x-axis (observer's direction) (the sky-plane from the observer) 
view([90,-olat*180/pi]);
if 0
pause
% view along the sun's direction (the sky-plane from the sun) 
view([90-dlon*180/pi,(olat-slat)*180/pi]);
end


function ebeta = eLimb(e,beta)

% eccentricty of the ellipse formed by the limb in its own plane for
% an observation latitude beta of an oblate ellipsoid with eccentricty e
% Eq A13

ebeta = e*sqrt(1-sin(beta)^2/(1-e^2*cos(beta)^2));



% algrebraic measure between point of the limb/terminator to cusp line eq 80
function D = dist(olat,slat,dlon,xs,ys)
D = cos(slat)*sin(dlon)*xs+...
    (-cos(slat)*cos(dlon)*sin(olat)+sin(slat)*cos(olat))*ys;

