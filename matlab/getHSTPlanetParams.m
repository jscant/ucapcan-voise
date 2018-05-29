function params = getHSTPlanetParams(params)
% function params = getHSTPlanetParams(params)

%
% $Id: getHSTPlanetParams.m,v 1.7 2015/09/27 18:57:48 patrick Exp $
%
% Copyright (c) 2012 Patrick Guio <patrick.guio@gmail.com>
% All Rights Reserved.
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 3 of the License, or (at your
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

HST = params.HST;

% load necessary SPICE kernels
planet = setUpSpice4Planet(HST);

IAU_PLANET = ['IAU_' upper(planet.name)];

% conversion factors
degPerRad = cspice_dpr;
radPerDeg = cspice_rpd;
radPerArcsec = radPerDeg/3600;
arcsecPerRad = degPerRad*3600;

radPerPixel = arcsecPerRad/HST.PLATESC;

% Convert string date to double precision 
et = cspice_str2et([HST.TDATEOBS ' ' HST.TTIMEOBS]);
% format YYY mmm dd HH:MM:SS 
epoch = cspice_et2utc(et,'C',0)
%epoch = datestr(datenum(epoch,'YYYY mmm dd HH:MM:SS'),'yyyy mm dd HH MM SS');

% flag for calculation in J2000
if 1,
isJ2000 = true;
else
isJ2000 = false;
end

% Get position of planet with respect to Earth
target   = planet.name;
if isJ2000,
frame    = 'J2000'; % Earth inertial frame
else
frame    = 'IAU_EARTH'; % Earth fixed frame
end
abcorr   = 'LT';   % Correct for one-way light time
observer = 'EARTH';
% Look up the 'state' vectors and light time values 'lt'  
% corresponding to the vector of input ephemeris time 'et'.
[state , lt] = cspice_spkezr(target, et, frame, abcorr, observer);
planetposn = state(1:3);
planetdist = cspice_vnorm(planetposn);

% Get planet ra/dec requires state in inertial J2000
[state , lt] = cspice_spkezr(target, et, 'J2000', 'LT', observer);
[range,ra,dec] = cspice_recrad(state(1:3,:));
planet.r = range;
% rad to deg
planet.ra = ra*degPerRad; 
planet.dec = dec*degPerRad;

fprintf(1,'planet    ra, dec = %12.6f,%12.6f deg\n',[planet.ra(:)';planet.dec(:)']);

% reference pixel image coordinates 
rpx = HST.CRPIX1;
rpy = HST.CRPIX2;
% reference pixel ra/dec coordinates (deg)
rpra = HST.CRVAL1;
rpdec = HST.CRVAL2;
% inverse matrix to transform from world to pixel coordinates
iCD = HST.iCD;
% planet world coordinates to pixel coordinates
[xpc,ypc] = getHSTradec2pixel(HST,planet.ra,planet.dec);

% Convert reference pixel ra/dec (target direction) to rect coordinates
refpixposn = cspice_radrec(planetdist, rpra*radPerDeg, rpdec*radPerDeg);
% Retrieve the transformation matrix from J2000 frame to IAU_EARTH frame
J2000toEarth = cspice_pxform('J2000', 'IAU_EARTH', et);
EarthtoJ2000 = cspice_pxform('IAU_EARTH', 'J2000', et);
% transform rectangular inertial coordinates into Earth frame
if ~isJ2000,
refpixposn = J2000toEarth*refpixposn;
end

fprintf(1,'planetposn        = %12.6g, %12.6g, %12.6g km\n', planetposn);
fprintf(1,'refpixposn        = %12.6g, %12.6g, %12.6g km\n', refpixposn);

refpix2planetangle = acosd(dot(cspice_vhat(planetposn),cspice_vhat(refpixposn)));
fprintf(1,'angle(planet,refpix)           = %f deg\n', refpix2planetangle);
fprintf(1,'|planet(ra,dec)-refpix(ra,dec) = %f deg\n', ...
norm([planet.ra-rpra;planet.dec-rpdec],2));

% zhat normalised vector from ref pixel pointing toward Earth in Earth ref
zhat = -cspice_vhat(refpixposn);
% get celestial north in Earth ref
if isJ2000,
north = EarthtoJ2000*[0;0;1];
else
north = [0;0;1];
end
% yhat is the projection of celestial north onto the image plane
% (the plane perpendicular to the line of sight defined by zhat)
% rotated by ORIENTAT - position angle of image y axis (deg. e of n)
yhat = cspice_vhat(north-dot(zhat,north)*zhat);
% rotate by ORIENTAT corresponding to the position angle of
% image y axis (deg. e of n)
yhatr = rot3d(zhat,HST.ORIENTAT,yhat);
%yhat = yhatr;
% angle between celestial north and its projection onto the image plane
%tprojnorth = acosd(dot(north,cspice_vhat(north-dot(zhat,north)*zhat)))
%zdoty = dot(zhat,yhat), % scalar product should be zero
% xhat such that (xhat,yhat,zhat) is direct
xhat = cross(yhat,zhat);
xhatr = cross(yhatr,zhat);
if 0
fprintf(1,'angle(y/xhat,y/xhatr)=%.2f,%.2f\n', ...
        [acosd(dot(yhat,yhatr)), acosd(dot(xhat,xhatr))]);
fprintf(1,'xhat(r).yhat(r)      =%.2g,%.2g\n',[dot(xhat,yhat), dot(xhatr,yhatr)])
end
% rotated axes
xhat = xhatr; yhat = yhatr;

% ref pixel position (xrp,yrp) should be zero
xrp = atan2(dot(refpixposn,xhat), planetdist)*radPerPixel;
yrp = atan2(dot(refpixposn,yhat), planetdist)*radPerPixel;
% positive means nearer to Earth than planet centre
zrp = planetdist+dot(refpixposn,zhat)
fprintf(1,'xrp, yrp          = %12.6g, %12.6g pixel\n', xrp, yrp);

if 1
% planet centre (Xpc,Ypc) in the image plane in km
% with respect to (0,0) that corresponds to refpixposn
Xpc = atan2(dot(planetposn,xhat), planetdist)*radPerPixel + rpx;
Ypc = atan2(dot(planetposn,yhat), planetdist)*radPerPixel + rpy; 
% positive means nearer to Earth than planet centre
Zpc = planetdist+dot(planetposn,zhat)
end

pc = [xpc-HST.CRPIX1, ypc-HST.CRPIX2];
PC = [Xpc-HST.CRPIX1, Ypc-HST.CRPIX2];
fprintf(1,'xpc, ypc, |pc|    = %12.6f, %12.6f, %12.6f pixel\n', pc, norm(pc));
fprintf(1,'xPC, yPC, |PC|    = %12.6f, %12.6f, %12.6f pixel\n', PC, norm(PC));
fprintf(1,'angle(pc,PC)      = %12.2f deg\n', acosd(dot(pc/norm(pc),PC/norm(PC))));


% get planet radii
radii = cspice_bodvrd(planet.name,'RADII',3);
a = radii(1); % equatorial radius (1 and 2)
b = radii(3); % polar radius
e = sqrt(a^2-b^2)/a; % excentricity

% if Saturn get rings parameters
if strcmp(planet.name,'saturn'),
  % A Ring, Encke Gap, Cassini Division, B Ring
  rings = {'RING1','RING1_1','RING2','RING3'};
	ringSpecs = zeros(5,length(rings));
	% Ring geometry is defined in the form of one set of R1, R2, Z1, Z2, OD where
	% R1 and R2 are inner and outer radii of the ring (in km)
	% Z1 and Z2 are the vertical heights of the ring at R1 and R2 (also in km, 
	% equal to one-half of the total thickness of the ring) 
	% OD is the average optical depth of the ring sub-segment/gap across R1 to R2.
	for i=1:length(rings),
   ringSpecs(:,i) = cspice_bodvrd(planet.name,rings{i},5);
	end
end

% Retrieve the transformation matrix from frame of the planet to IAU_EARTH.
if 1, 
% one-way light time corrected epoch
planet2Earth = cspice_pxform(IAU_PLANET, 'IAU_EARTH', et-lt);
else
planet2Earth = cspice_pxform(IAU_PLANET, 'IAU_EARTH', et);
end
% planet axis direction (pointing north) in Earth frame (or inertial J2000)
if ~isJ2000,
planetaxis = planet2Earth*[0;0;1];
else
planetaxis = EarthtoJ2000*(planet2Earth*[0;0;1]);
end


% angle between planet axis and projection onto the image plane
tprojplanetaxis = acosd(dot(planetaxis,cspice_vhat(planetaxis-dot(zhat,planetaxis)*zhat)));
fprintf(1,'tprojplanetaxis      = %12.2g deg\n', tprojplanetaxis);
fprintf(1,'cos(tprojplanetaxis) = %12.2g\n', cosd(tprojplanetaxis)),
planetaxis3d = planetaxis;
% projection of the planet axis onto the plane of the image
planetaxis = cspice_vhat(planetaxis-dot(zhat,planetaxis)*zhat);
fprintf(1,'planetaxis (Earth r) = %12.6f, %12.6f, %12.6f\n', planetaxis);
xplanetaxis = dot(planetaxis,xhat);
yplanetaxis = dot(planetaxis,yhat);
xplanetaxis/yplanetaxis
pause
planetaxis = [xplanetaxis,yplanetaxis];
fprintf(1,'planetaxis (image)   = %12.6f, %12.6f\n', planetaxis);

[xmg,ymg,zmg,xpg,ypg,zpg,N,S] = spheroidGrid(planetaxis3d,a,b,xhat,yhat,zhat);

% add offset to planet centre
xmg = xmg+planetposn(1); ymg = ymg+planetposn(2); zmg = zmg+planetposn(3);
Xmg =zeros(size(xmg)); Ymg =zeros(size(xmg)); Zmg =zeros(size(xmg));
for i=1:length(xmg(:)),
  % projection onto the image plane
  posn = [xmg(i);ymg(i);zmg(i)];
  Xmg(i) = atan2(dot(posn,xhat), planetdist)*radPerPixel + rpx;
  Ymg(i) = atan2(dot(posn,yhat), planetdist)*radPerPixel + rpy;
  % positive means nearer to Earth than planet centre
  Zmg(i) = planetdist+dot(posn,zhat);
end
Xmg(Zmg<0) = NaN;
Ymg(Zmg<0) = NaN;

% add offset to planet centre
xpg = xpg+planetposn(1); ypg = ypg+planetposn(2); zpg = zpg+planetposn(3);
Xpg =zeros(size(xpg)); Ypg =zeros(size(xpg)); Zpg =zeros(size(xpg));
for i=1:length(xpg(:)),
  % projection onto the image plane
  posn = [xpg(i);ypg(i);zpg(i)];
  Xpg(i) = atan2(dot(posn,xhat), planetdist)*radPerPixel + rpx;
  Ypg(i) = atan2(dot(posn,yhat), planetdist)*radPerPixel + rpy;
  % positive means nearer to Earth than planet centre
  Zpg(i) = planetdist+dot(posn,zhat);
end
Xpg(Zpg<0) = NaN;
Ypg(Zpg<0) = NaN;

% North pole
XN = atan2(dot(N,xhat), planetdist)*radPerPixel + rpx;
YN = atan2(dot(N,yhat), planetdist)*radPerPixel + rpy;
ZN = planetdist+dot(N,zhat)
ZN = dot(N,zhat)

% South pole
XS = atan2(dot(S,xhat), planetdist)*radPerPixel + rpx;
YS = atan2(dot(S,yhat), planetdist)*radPerPixel + rpy;
ZS = dot(S,zhat)

% poles computed in world (ra/dec) and transformed to pixel coordinates
if ~isJ2000,
planetnorth = EarthtoJ2000*(planetposn+planet2Earth*[0;0;b]);
planetsouth = EarthtoJ2000*(planetposn+planet2Earth*[0;0;-b]);
else
planetnorth = planetposn+EarthtoJ2000*(planet2Earth*[0;0;b]);
planetsouth = planetposn+EarthtoJ2000*(planet2Earth*[0;0;-b]);
end
[northrange,northra,northdec] = cspice_recrad(planetnorth);
[southrange,southra,southdec] = cspice_recrad(planetsouth);
[xn,yn] = getHSTradec2pixel(HST,northra*degPerRad,northdec*degPerRad);
[xs,ys] = getHSTradec2pixel(HST,southra*degPerRad,southdec*degPerRad);

% equator computed in world (ra/dec) and transformed to pixel coordinates,
lat = 0;
lon = linspace(0,2*pi,100);
planeteq = zeros(3,length(lon));
for i=1:length(lon);
  posn = [a*cos(lat)*cos(lon(i));a*cos(lat)*sin(lon(i));b*sin(lat)];
	if ~isJ2000,
	planeteq(:,i) = EarthtoJ2000*(planetposn+planet2Earth*posn);
	else
	planeteq(:,i) = planetposn+EarthtoJ2000*(planet2Earth*posn);
	end
end
[eqrange,eqra,eqdec] = cspice_recrad(planeteq);
[xeq,yeq] = getHSTradec2pixel(HST,eqra*degPerRad,eqdec*degPerRad);

% meridian computed in world (ra/dec) and transformed to pixel coordinates
lat = linspace(-pi/2,pi/2,100);
lon = 0;
planetmerid = zeros(3,length(lat));
for i=1:length(lat);
  posn = [a*cos(lat(i))*cos(lon(1));a*cos(lat(1))*sin(lon(1));b*sin(lat(i))];
	if ~isJ2000,
  planetmerid(:,i) = EarthtoJ2000*(planetposn+planet2Earth*posn);
	else
  planetmerid(:,i) = planetposn+EarthtoJ2000*(planet2Earth*posn);
	end
end
[meridrange,meridra,meriddec] = cspice_recrad(planetmerid);
[xmerid,ymerid] = getHSTradec2pixel(HST,meridra*degPerRad,meriddec*degPerRad);


if strcmp(planet.name,'saturn'),
% Saturn's ring computed in world (ra/dec) and transformed to pixel coordinates,
lon = linspace(0,2*pi,100);
for j = 1:length(rings),
rmn{j} =  zeros(3,length(lon));
rmx{j} =  zeros(3,length(lon));
for i=1:length(lon);
  posn = [ringSpecs(1,j)*cos(lon(i));ringSpecs(1,j)*sin(lon(i));0];
	if ~isJ2000,
	rmn{j}(:,i) = EarthtoJ2000*(planetposn+planet2Earth*posn);
	else
	rmn{j}(:,i) = planetposn+EarthtoJ2000*(planet2Earth*posn);
	end
  posn = [ringSpecs(2,j)*cos(lon(i));ringSpecs(2,j)*sin(lon(i));0];
	if ~isJ2000,
	rmx{j}(:,i) = EarthtoJ2000*(planetposn+planet2Earth*posn);
	else
	rmx{j}(:,i) = planetposn+EarthtoJ2000*(planet2Earth*posn);
	end
end
[rmnr{j},rmnra{j},rmndec{j}] = cspice_recrad(rmn{j});
[xrmn{j},yrmn{j}] = getHSTradec2pixel(HST,rmnra{j}*degPerRad,rmndec{j}*degPerRad);
[rmxr{j},rmxra{j},rmxdec{j}] = cspice_recrad(rmx{j});
[xrmx{j},yrmx{j}] = getHSTradec2pixel(HST,rmxra{j}*degPerRad,rmxdec{j}*degPerRad);
end
end

% correction for projection on the plane of the polar radii
bp = b*cosd(tprojplanetaxis);

% projection of semi-major and semi minor axis in pixels
a = atan2(a,planetdist)*radPerPixel;
b = atan2(b,planetdist)*radPerPixel;
bp = atan2(bp,planetdist)*radPerPixel;
% tilt in the plane of the image with respect to x axis
tilt = atan2(planetaxis(2),planetaxis(1))*degPerRad;

fprintf(1,'planet disc  a, b, bp  = %12.1f, %12.1f, %12.1f pixel, tilt = %5.1f deg\n',...
a,b,bp,tilt);

if strcmp(planet.name,'saturn'),
% correction for projection on the plane
%ARmin = ARmin*cosd(tprojplanetaxis);
end

% plot an ellipse with planet parameters, i.e. a, b, tilt
theta = linspace(0,360,100);
% ellipse with axis along x axis
ellx = b*sind(theta);
elly = a*cosd(theta);
% rotation by tilt
ell = rot2d(tilt,[ellx;elly]);
ellx = ell(1,:);
elly = ell(2,:);


opts = {'fontsize',12,'fontweight','normal'}; %,'color','black'};

% north-south pole axis in the image
xAxis = [1;-1]*planetaxis(1)*bp;
yAxis = [1;-1]*planetaxis(2)*bp;

if 0
plot(ellx,elly,xAxis,yAxis)
text(xAxis(1),yAxis(1),'NAxis',opts{:});
text(xAxis(2),yAxis(2),'SAxis',opts{:});
axis equal
pause
end

figure
% load color values
h=plot(ones(10));
for i=1:length(h),
  colors{i} = get(h(i),'color');
end
clear h
close

[ss,se]=computePlanetAxis(planet.name,epoch);

% get limb, terminator and cusp point assuming rotation axis is measured
% from y-axis, needs a rotation of tilt+90 deg
[ll,ld,tl,td,cusp]=getLTC(a,e,se,ss);
pause
if 1
% rotation by tilt+90 deg to take into account that getLTC returns the geometry
% with rotation axis vertical and that tilt is with respect to x-axis
tmp = rot2d(tilt+90,[ll{1};ll{2}]);
ll{1} = tmp(1,:);
ll{2} = tmp(2,:);
tmp = rot2d(tilt+90,[ld{1};ld{2}]);
ld{1} = tmp(1,:);
ld{2} = tmp(2,:);
tmp = rot2d(tilt+90,[tl{1};tl{2}]);
tl{1} = tmp(1,:);
tl{2} = tmp(2,:);
tmp = rot2d(tilt+90,[td{1};td{2}]);
td{1} = tmp(1,:);
td{2} = tmp(2,:);
tmp = rot2d(tilt+90,[cusp{1};cusp{2}]);
cusp{1} = tmp(1,:);
cusp{2} = tmp(2,:);
end

plot(Xmg,Ymg,'k-');
hold on
plot(Xpg,Ypg,'k-');
XN = dot(N,xhat);
YN = dot(N,yhat);
ZN = dot(N,zhat);
XS = dot(S,xhat);
YS = dot(S,yhat);
ZS = dot(S,zhat);
if 0
plot([XN,XS]+Xpc,[YN,YS]+Ypc,'bx')
text(XN+Xpc,YN+Ypc,'N')
text(XS+Xpc,YS+Ypc,'S')
end
% cusp, limb and terminator
plot(cusp{1}+Xpc,cusp{2}+Ypc,'ko','Markersize',10);
plot(ll{1}+Xpc,ll{2}+Ypc,'c-',tl{1}+Xpc,tl{2}+Ypc,'m-','Linewidth',2);
plot(ld{1}+Xpc,ld{2}+Ypc,'c--',td{1}+Xpc,td{2}+Ypc,'m--','Linewidth',1);
hold off
disp('problem')
pause

% get image and axes
W = params.W;
[nr,nc] = size(W);
clf
X = [1:nc];
Y = [1:nr];

if ~strcmp(planet.name,'jupiter'),
% create an image with the template ellipse centered
Wt = zeros(size(W));
[Xgrid, Ygrid] = meshgrid([1:size(W,2)]-Xpc,[1:size(W,1)]-Ypc);
XYrot = rot2d(-tilt-90,[Xgrid(:)';Ygrid(:)']);
Xgrid = reshape(XYrot(1,:), size(Xgrid));
Ygrid = reshape(XYrot(2,:), size(Ygrid));
Wt(Xgrid.^2/a^2+Ygrid.^2/b^2<=1) = 1;

figure
subplot(121),
imagesc(X,Y,log10(abs(W))),
axis xy
axis square

subplot(122),
imagesc(X,Y,Wt)
axis xy
axis square

figure

%[i,j] = getOptimalCorrel(W, Wt);
ss = 4;
[i,j] = getOptimalCorrel(W(1:ss:end,1:ss:end), Wt(1:ss:end,1:ss:end));
i = ss*i; j = ss*j;

%rpx = rpx+j; rpy = rpy+i;
xpc = xpc+j; ypc = ypc+i;
xn = xn +j; yn = yn+i;
xs = xs +j; ys = ys+i;
xeq = xeq+j; yeq = yeq+i;
xmerid = xmerid+j; ymerid = ymerid+i;
Xpc = Xpc+j; Ypc = Ypc+i;
Xmg = Xmg+j; Ymg = Ymg+i;
Xpg = Xpg+j; Ypg = Ypg+i;
if strcmp(planet.name,'saturn'),
for i=1:length(rings),
  xrmn{i} = xrmn{i}+j; yrmn{i} = yrmn{i}+i;
	xrmx{i} = xrmx{i}+j; yrmx{i} = yrmx{i}+i;
end
end

end

figure
imagesc(X,Y,log10(abs(W)))
axis xy
hold on
axis auto
plot(rpx,rpy,'b+','markersize',10), text(rpx,rpy,'O',opts{:})

% using HST transformation from/to world to/from pixel coordinates and SPICE
plot(xpc,ypc,'bx','markersize',10), text(xpc,ypc,'(xpc,ypc)',opts{:})
plot([xn;xs],[yn;ys],'bo-','markersize',10), 
text([xn;xs],[yn;ys],['N';'S'],opts{:},'color','b'),
plot(xeq,yeq,'bo-',xmerid,ymerid,'bo-');
if strcmp(planet.name,'saturn'),
for i=1:length(rings),
plot(xrmn{i},yrmn{i},'o-','color',colors{i});
plot(xrmx{i},yrmx{i},'o-','color',colors{i});
end
end

% using HST ref pixel, y-axis orientation, plate scale and SPICE
plot(Xpc,Ypc,'kx','markersize',10), text(Xpc,Ypc,'(Xpc,Ypc)',opts{:})
%plot(ellx+Xpc,elly+Ypc,'k-',xAxis+Xpc,yAxis+Ypc,'g-')
text(xAxis+Xpc,yAxis+Ypc,['NAxis';'SAxis'],opts{:},'color','k')
plot(Xmg,Ymg,'k-'); % meridian
plot(Xpg,Ypg,'k-'); % parallel

% cusp, limb and terminator
plot(cusp{1}+Xpc,cusp{2}+Ypc,'wo','Markersize',10);
plot(ll{1}+Xpc,ll{2}+Ypc,'y-',ld{1}+Xpc,ld{2}+Ypc,'y--','Linewidth',2);
plot(tl{1}+Xpc,tl{2}+Ypc,'w-',td{1}+Xpc,td{2}+Ypc,'w--','Linewidth',2);

hold off
axis equal
%pause


fac = 1.15;
set(gca,'xlim',[max(1,xpc-fac*max(a,b)), min(nc,xpc+fac*max(a,b))])
set(gca,'ylim',[max(1,ypc-fac*max(a,b)), min(nr,ypc+fac*max(a,b))])

% Embed planet structure into params
params.planet = planet;

%  It's always good form to unload kernels after use,
%  particularly in MATLAB due to data persistence.
cspice_kclear


function P = rot2d(alpha,P)

% P is a 2xN vector

x = P(1,:);
y = P(2,:);

ca = cosd(alpha);
sa = sind(alpha);

X = x*ca - y*sa;
Y = x*sa + y*ca;

P(1,:) = X;
P(2,:) = Y;


function P = rot3d(u,alpha,P)

% from http://en.wikipedia.org/wiki/Rotation_matrix

% P is a 3xN vector
x = P(1,:);
y = P(2,:);
z = P(3,:);

ca = cosd(alpha);
sa = sind(alpha);

if 0,
uxx = u(1)*u(1);
uyy = u(2)*u(2);
uzz = u(3)*u(3);
uxy = u(1)*u(2);
uxz = u(1)*u(3);
uyz = u(2)*u(3);;

X = (ca+uxx*(1-ca))*x      + (uxy*(1-ca)-u(3)*sa)*y + (uxz*(1-ca)+u(2)*sa)*z;
Y = (uxy*(1-ca)+u(3)*sa)*x + (ca+uyy*(1-ca))*y      + (uyz*(1-ca)-u(1)*sa)*z;
Z = (uxz*(1-ca)-u(2)*sa)*x + (uyz*(1-ca)+u(1)*sa)*y + (ca+uzz*(1-ca))*z;

else

% identity matrix
I = eye(3,3);
% cross product matrix
u_x = [0, -u(3), u(2); u(3), 0, -u(1); -u(2), u(1), 0];
% tensor product 
uxu = u(:)*u(:)';
% Rotation matrix
R = I*ca + sa*u_x+(1-ca)*uxu;

X = R(1,1)*x + R(1,2)*y + R(1,3)*z;
Y = R(2,1)*x + R(2,2)*y + R(2,3)*z;
Z = R(3,1)*x + R(3,2)*y + R(3,3)*z;

end

P(1,:) = X;
P(2,:) = Y;
P(3,:) = Z;
