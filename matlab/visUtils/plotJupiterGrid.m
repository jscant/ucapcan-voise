function plotJupiterGrid(params, p, epoch, CML, PIXSIZE)
% function plotJupiterGrid(params, p, epoch, CML, PIXSIZE)

%
% $Id: plotJupiterGrid.m,v 1.18 2015/12/18 15:18:50 patrick Exp $
%
% Copyright (c) 2009 
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

%subplot(224)
subplot(111)

% Latitude and longitude spacing for plots [deg]
dlat = 10; 
dlon = 20;

% Pixel coordinates for planet centre
PCX = p(1); 
PCY = p(2);
fprintf(1,'Planet centre %8.2f, %8.2f [pixels]\n', PCX,PCY);

% calculation of the subEarth and subSolar latitudes and longitudes
[sslat,sslon,selat,selon,sedistAU,AU_km] = computeJupiterAxis(epoch);

if length(p)==2,
  semiMaj_km = [];
	ecc = [];
else
  A = p(3);
  if length(p)==3,
    B = p(3);
  elseif length(p)==5,
    B = p(4);
  end
  [a,b,e,f] = getPlanetGeometry('Jupiter');
  % rad to arcsec (180/pi)*3600
  a = A*(sedistAU*AU_km)/(180/pi)/3600*PIXSIZE; % in km
  bp = B*(sedistAU*AU_km)/(180/pi)/3600*PIXSIZE; % in km
	b = bp * sqrt((1-e^2)/(1-e^2*cos(pi/180*selat)^2)); % in km
	fprintf(1,'a = %.0f b = %.0f bp = %.0f\n', a, b, bp);
	if 1
  ecc = sqrt(1-(b/a)^2);
	else
  ecc = e;
	end
  semiMaj_km = a;
  fprintf(1,'Semi-major axis = %.0f km Eccentricity = %.5f\n',semiMaj_km, ecc);
end



% Draw the image data, on a scale of arcsec
% Note that PIXSIZE is the size of one side of a square pixel in arcsec
x = PIXSIZE*(params.x-PCX);
y = PIXSIZE*(params.y-PCY);

imagesc(x, y, params.Wo);
axis xy;
axis equal
axis tight
xlabel('x [arcsec]')
ylabel('y [arcsec]')
%title(sprintf('[%.2f,%.2f]x[%.2f,%.2f] [arcsec]',min(x),max(x),min(y),max(y)));
%title(sprintf('%.2fx%.2f [arcsec]',max(x)-min(x),max(y)-min(y)));
title(sprintf('epoch %s',epoch));

tic
if 0,
  drawPlanetGridOld(epoch,CML,dlat,dlon);
else,
  drawPlanetGrid(epoch,CML,dlat,dlon,semiMaj_km,ecc);
end
toc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawPlanetGrid(epoch,CML,dlat,dlon,semiMaj_km,ecc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get parameters from SPICE
[semiMaj_km1,b1,ecc1,f1] = getPlanetGeometry('Jupiter');
fprintf(1,'Semi-major axis = %.0f km Eccentricity = %.5f\n',semiMaj_km1, ecc1);
if ~exist('semiMaj_km','var') || isempty(semiMaj_km) || ...
   ~exist('ecc','var') || isempty(ecc),
semiMaj_km = semiMaj_km1;
ecc = ecc1;
end
% calculation of the subEarth and subSolar latitudes and longitudes 
[sslat,sslon,selat,selon,sedistAU,AU_km] = computeJupiterAxis(epoch);

fprintf(1,'Earth-Jupiter distance = %.4f AU (1 AU = %.3f km)\n',sedistAU,AU_km);

% Get difference between (right-handed) subearth and subsolar longitudes.
% Although these two quantities will vary on time scale of Jupiter rotation
% (10 hrs), their *difference* varies much more slowly. 
% Note that a *positive* value means that the Sun meridian is
% situated ahead of the Earth's (in the direction of planetary rotation)
ssedlon = sslon - selon;

%Sub-Earth colatitude in radians
theobs = pi/2 - selat*pi/180;
% Central meridian longitude in a right-handed system
phiobs = 2*pi - CML*pi/180;

%Sub-Solar colatitude in radians
thesun = pi/2 - sslat*pi/180;

% Scaling factor to convert from km to arcsec on the plane of 
% the Earth observer's sky
scalfac = (1/(sedistAU*AU_km))*(180/pi)*3600;

mfig = gcf;
figure
r = semiMaj_km*scalfac;
se = struct('lat',selat,'lon',selon);
ss = struct('lat',sslat,'lon',sslon);
[xll,yll,xld,yld,xtl,ytl,xtd,ytd,xc,yc] = ltc(r,ecc,se,ss);
%xc',yc'
figure(mfig)

% Calculate the viewing angle
lineOfSight = [sin(theobs)*cos(phiobs);sin(theobs)*sin(phiobs);cos(theobs)];

hold on

% Grid curves of constant latitude
for the = [0:dlat:180]*pi/180,

	phi = linspace(0,2*pi,50); 

	[r,x,y,z,xsky,ysky] = spherical2Sky(semiMaj_km,ecc, ...
	                                    the,phi,theobs,phiobs,scalfac);

  cos_vang = lineOfSight(1)*x/r+lineOfSight(2)*y/r+lineOfSight(3)*z/r;

	flag_vang = (cos_vang > 0);
	Xv = xsky(flag_vang);
	Yv = ysky(flag_vang);
	[Xv,I] = sort(Xv);
	Yv = Yv(I);
  plot(Xv,Yv,'k-','LineWidth',.5);
	if 0
	Xh = xsky(~flag_vang);
	Yh = ysky(~flag_vang);
	[Xh,I] = sort(Xh);
	Yh = Yh(I);
  plot(Xh,Yh,'k--','LineWidth',.5);
	end
end

% Grid curves of constant longitude
for phi = [0:dlon:360]*pi/180,

  the = linspace(0,pi,50);

	[r,x,y,z,xsky,ysky] = spherical2Sky(semiMaj_km,ecc, ...
	                                    the,phi,theobs,phiobs,scalfac);

  cos_vang = lineOfSight(1)*x./r+lineOfSight(2)*y./r+lineOfSight(3)*z./r;

  flag_vang = (cos_vang > 0);
	Xv = xsky(flag_vang);
	Yv = ysky(flag_vang);
	[Yv,I] = sort(Yv);
	Xv = Xv(I);
	if phi>0,
  plot(Xv,Yv,'k-','LineWidth',.5);
	else, % phi==0,
	plot(Xv,Yv,'k-','LineWidth',1.0);
	end
	if 0
	Xh = xsky(~flag_vang);
	Yh = ysky(~flag_vang);
	[Yh,I] = sort(Yh);
	Xh = Xh(I);
  plot(Xh,Yh,'k--','LineWidth',.5);
	end
end

% Calculate the edge of the planet disc on the sky
the = linspace(0,pi,200);

discrim = abs(cos(the).*cos(theobs))-(1-ecc^2)*abs(sin(the).*sin(theobs));
the = the(discrim < 0);

phi_rel = acos(-cos(the).*cos(theobs)./((1-ecc^2)*sin(the).*sin(theobs)));
phi = phi_rel + phiobs;

[r,x,y,z,xsky,ysky] = spherical2Sky(semiMaj_km,ecc, ...
                                    the,phi,theobs,phiobs,scalfac);

%plot(xsky, ysky, 'r-', -xsky, ysky, 'r-','LineWidth',1);
plot(xsky, ysky, 'r-', 'LineWidth',1);

% Repeat the above calculation for the locus of the day/night terminator
the = linspace(0,pi,200);

discrim = abs(cos(the).*cos(thesun))-(1-ecc^2)*abs(sin(the).*sin(thesun));
the = the(discrim < 0);

phi_rel = acos(-cos(the).*cos(thesun)./((1-ecc^2)*sin(the).*sin(thesun)));

% Retrieve the longitudes of the points on the 
% terminator, taking into account the difference between
% the longitude of the Earth (obs) and Sun

fprintf(1,'Sun is at relative longitude %.4f to sub-Earth point\n', ssedlon);

phi1 =  phi_rel + phiobs + ssedlon*pi/180.;
phi2 = -phi_rel + phiobs + ssedlon*pi/180.;

phi = [phi1,phi2];
the = [the, the];

[r,x,y,z,xsky,ysky,zsky] = spherical2Sky(semiMaj_km,ecc, ...
                                         the,phi,theobs,phiobs,scalfac);


flag_zsky = (zsky*sign(ssedlon) > 0);
xsky = xsky(flag_zsky);
ysky = ysky(flag_zsky);

if 1
% trick to avoid "jumps" in theta
dt=diff(atan2(ysky,xsky));
ii=find(abs(dt)>2*min(abs(dt)));
xsky(ii) = NaN;
ysky(ii) = NaN;
end

plot(xsky, ysky, 'g-','LineWidth',1);

hold off


function [r,x,y,z,xsky,ysky,varargout]=spherical2Sky(a,e,the,phi,theobs,phiobs,scalfac)

r = a*sqrt(1-e^2)./sqrt(1-(e*sin(the)).^2);

x = r .* sin(the) .* cos(phi);
y = r .* sin(the) .* sin(phi);
z = r .* cos(the);

% Project planetary position onto the plane of the sky
xsky = -x*sin(phiobs) + y*cos(phiobs);
ysky = (-x*cos(phiobs)-y*sin(phiobs))*cos(theobs)+z*sin(theobs);

% Transform to arc seconds 
xsky = scalfac*xsky;
ysky = scalfac*ysky;

if nargout > 6,
zsky = x*sin(theobs)*cos(phiobs)+y*sin(theobs)*sin(phiobs)+z*cos(theobs);
varargout(1) = {zsky};
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawPlanetGridOld(epoch,CML,dlat,dlon)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Central meridian longitude SIII
  geom_config.subEarthLongSIII_deg = CML; 
% Geometry information structure for the planet (Jupiter)
% Eccentricity of the spheroid (planet 1B surface)
geom_config.ecc = 3.543200000000000e-01; 
% Semimajor axis km
geom_config.semimajoraxis_km = 71492.;    

% Sub-Earth latitude as a function of time is determined
% by the get_subearth_latitude routine (see below)

% Jupiter-Earth distance in AU for the reduced images
geom_config.distToEarth_AU = 4.200000000000000e+00;   

% Name of file containing sub-Earth latitude as a function of time:
geom_config.ephemFileName = '/home/patrick/research/codes/Aurora/jup_axis.txt';

% The get_subearth_latitude routine calculates the subEarth and subSolar
% latitudes and longitudes and adds these values to the fields of geom_config
matlab_date = str2num(epoch); 
geom_config = get_subearth_latitude(geom_config, matlab_date);
[hFigure, geom_config] = draw_planet_grid(geom_config, dlat, dlon, gcf);

