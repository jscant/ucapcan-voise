function [ss,se]=computePlanetAxis(planet,epoch)
% function [ss,se]=computePlanetAxis(planet,epoch)
% 
% compute sub-solar (ss) and sub-Earth (se) points parameters for 
% a given planet (or Moon) and epoch
% 
% ss.rad, se.rad       : distance [km] of sub-solar/Earth point from
%                        planet centre
% ss.lon, se.lon       : planetocentric longitude [deg] in planet's fixed frame
% ss.lat, ss.lat       : planetocentric latitude [deg] in planet's fixed frame
% ss.trgepc, se.trgepc : sub-solar/Earth point epoch
% ss.dist, se.dist     : distance [km] from planet to Sun/Earth 
% se.CML               : CML of the planet seen from the Earth in
%                        planetographic longitude
% se.psi               : Orientation of the planet's axis with respect 
%                        to the sky North (0 means aligned to North)

%
% $Id: computePlanetAxis.m,v 1.17 2018/06/14 11:41:04 patrick Exp $
%
% Copyright (c) 2012
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

planet = lower(planet);
PLANET = upper(planet);
Planet = [PLANET(1) planet(2:end)];
IAU_PLANET = ['IAU_' PLANET];

% conversion factor
r2d = cspice_dpr;

% Correct for one-way light time and stellar aberration using a Newtonian
% formulation. This option modifies the state obtained with the 'LT' option to
% account for the observer's velocity relative to the solar system barycenter.
% The result is the apparent sub-observer point as seen by the observer
%abcorr   = 'LT+S';

% Converged Newtonian light time and stellar aberration corrections. This
% option produces a solution that is at least as accurate at that obtainable
% with the 'LT+S' option. Whether the 'CN+S' solution is substantially more
% accurate depends on the geometry of the participating objects and on the
% accuracy of the input data. In all cases this routine will execute more
% slowly when a converged solution is computed
abcorr   = 'CN+S';

% body-fixed, body-centered reference frame associated with the target body
fixref = IAU_PLANET;

% Nearest point on the target relative to the Sun/observer
%method = 'Near point: ellipsoid';

% Target surface intercept of the line containing the Sun/observer and
% the target's center
method = 'Intercept:  ellipsoid';

% load necessary kernels
loadPlanetSpiceKernels(planet);

% re, f are equatorial radius and flattening of the planet
% necessary for cspice_recpgr()
radii = cspice_bodvrd(PLANET,'RADII',3);
re = radii(1);
f = (radii(1)-radii(3))/radii(1);

% convert UTC to ephemeris time 
et = cspice_str2et(epoch);

if 0,
% get pic format used
[pic, ok, xerror] = cspice_tpictr(epoch);
% print epoch with this format
fprintf(1,'Epoch %s\n', cspice_timout(et, pic));
end

% Sub-solar point calculations
fprintf(1,'Sub-Solar Point\n');
fprintf(1,'---------------\n');

% Get position of the Sun with respect to planet 
target = 'SUN'; 
obsrvr = PLANET;
% state=[x,y,z,vx,vy,vz]' (6xn) and light time 'ltime' n-vector 
% for ephemeris time 'et' n-vector.
[state,ltime] = cspice_spkezr(target,et,fixref,abcorr,obsrvr); 
% converts rectangular coordinates to latitudinal coordinates
% lon increasing dir from +X axis towards +Y axis, rad units in range [-pi, pi]
% lat rad units in range [-pi/2, pi/2]
ssposn = state(1:3);
[ssrad,sslon,sslat] = cspice_reclat(ssposn);
fprintf(1,'ssc  rad %10.f lat %+9.4f lon %+9.4f\n',ssrad,[sslat,sslon]*r2d);
if 0,
ssrd1 = norm(ssposn);
ssln1 = atan2(ssposn(2), ssposn(1))*r2d;
sslt1 = 90 - acos(ssposn(3)/ssrd1)*r2d;
fprintf(1,'ssc1  rad %10.f lat %+9.4f lon %+9.4f\n',ssrd1,[sslt1,ssln1]);
fprintf(1,'diff %+10.2g     %+9.2g     %+9.2g\n',...
        ssrad-ssrd1,sslat*r2d-sslt1,sslon*r2d-ssln1)
end
% converts rectangular coordinates to planetographic coordinates
% for bodies with prograde (aka direct) rotation lon increasing dir 
% positive west (from +X axis towards -Y axis)
% for bodies with retrograde rotation lon increasing dir
% positive east (from +X axis towards +Y axis)
% The earth, moon, and sun are exceptions: planetographic 
% longitude is measured positive east for these bodies.
% lon increasing dir from +X axis towards +Y axis, rad units in range [-pi, pi]
% lat rad units in range [-pi/2, pi/2]
% for point not on the reference spheroid, lat is that of the closest point
% on the spheroid
[lon,lat,alt] = cspice_recpgr(PLANET,ssposn,re,f);
fprintf(1,'ssg  alt %10.f lat %+9.4f lon %+9.4f\n',alt,[lat,lon]*r2d);

% Compute sub-solar point with spice function
target = PLANET;
obsrvr = 'EARTH';
[spoint,trgepc,srfvec] = cspice_subslr(method,target,et,fixref,abcorr,obsrvr);
% Convert sub-solar point's rectangular coordinates to
% planetocentric radius, longitude and latitude
[spcrad,spclon,spclat] = cspice_reclat(spoint);
% and to planetographic longitude, latitude and altitude
[spglon,spglat,spgalt] = cspice_recpgr(target,spoint,re,f);

% Compute Sun's apparent position relative to the target's center at trgepc
[sunpos,sunlt] = cspice_spkpos('SUN',trgepc,fixref,abcorr,target);
% Express the Sun's location in planetocentric coordinates
[supcrd,supcln,supclt] = cspice_reclat(sunpos);
% and to planetographic longitude, latitude and altitude
[supgln,supglt,supgal] = cspice_recpgr(target,sunpos,re,f);

fprintf(1,'spc  rad %10.f lat %+9.4f lon %+9.4f\n',spcrad,[spclat,spclon]*r2d);
fprintf(1,'spg  alt %10.f lat %+9.4f lon %+9.4f\n',spgalt,[spglat,spglon]*r2d);
fprintf(1,'supc rad %10.f lat %+9.4f lon %+9.4f\n',supcrd,[supclt,supcln]*r2d);
fprintf(1,'supg alt %10.f lat %+9.4f lon %+9.4f\n',supgal,[supglt,supgln]*r2d);
fprintf(1,'---------------\n');

% Return Sun position to the planet
%[ss.rad,ss.lon,ss.lat] = deal(ssrad,sslon*r2d,sslat*r2d); %ss
% Return sub-solar point parameters
[ss.rad,ss.lon,ss.lat] = deal(spcrad,spclon*r2d,spclat*r2d); %ss
%[ss.rad,ss.lon,ss.lat] = deal(supcrd,supclt*r2d,supcln*r2d); %ss
ss.trgepc = trgepc;
ss.spoint = spoint;

% Planet-Sun in AU
ss.dist = supcrd;
ss.distAU = cspice_convrt(ss.dist,'KM','AU');

% and Sub-Earth Point
fprintf(1,'Sub-Earth Point\n');
fprintf(1,'---------------\n');
% Get position of Earth with respect to planet 
target   = 'EARTH';
obsrvr   = PLANET;
[state,ltime] = cspice_spkezr(target,et,fixref,abcorr,obsrvr);
seposn = state(1:3);
[serad,selon,selat] = cspice_reclat(seposn);
fprintf(1,'sec  rad %10.f lat %+9.4f lon %+9.4f\n',serad,[selat,selon]*r2d);
if 0,
serd1  = norm(seposn);
seln1  = atan2(seposn(2), seposn(1))*r2d;
selt1   = 90 - acos(seposn(3)/serd1)*r2d;
fprintf(1,'sec1  rad %10.f lat %+9.4f lon %+9.4f\n',serd1,[selt1,seln1]);
fprintf(1,'diff %+10.2g     %+9.2g     %+9.2g\n',...
        serad-serd1,selat*r2d-selt1,selon*r2d-seln1)
end

target = PLANET;
obsrvr = 'EARTH';
% Compute the sub-observer point
[spoint,trgepc,srfvec] = cspice_subpnt(method,target,et,fixref,abcorr,obsrvr);

% Compute the observer's distance from SPOINT
odist = norm(srfvec);
% Convert sub-observer point's rectangular coordinates to
% planetocentric radius, longitude and latitude
[spcrad,spclon,spclat] = cspice_reclat(spoint);
% and to planetographic longitude, latitude and altitude
[spglon,spglat,spgalt] = cspice_recpgr(target,spoint,re,f);

% Compute the observer's position relative to the center of the target, 
% where the center's location has been adjusted using
% the aberration corrections applicable to the sub-point.
obspos = spoint - srfvec;
% Express the observer's location in planetocentric coordinates
[opcrad,opclon,opclat] = cspice_reclat(obspos);
% and to planetographic longitude, latitude and altitude
[opglon,opglat,opgalt] = cspice_recpgr(target,obspos,re,f);

fprintf(1,'spc  rad %10.f lat %+9.4f lon %+9.4f\n',spcrad,[spclat,spclon]*r2d);
fprintf(1,'spg  alt %10.f lat %+9.4f lon %+9.4f\n',spgalt,[spglat,spglon]*r2d);
fprintf(1,'opc  rad %10.f lat %+9.4f lon %+9.4f\n',opcrad,[opclat,opclon]*r2d);
fprintf(1,'opg  alt %10.f lat %+9.4f lon %+9.4f\n',opgalt,[opglat,opglon]*r2d);

fprintf(1,'---------------\n');

% Return Earth position
[se.rad,se.lon,se.lat] = deal(serad,selon*r2d,selat*r2d); 
% Return sub-Earth point parameters
[se.rad,se.lon,se.lat] = deal(spcrad,spclon*r2d,spclat*r2d); 
se.trgepc = trgepc;
se.spoint = spoint;

% Planet-Earth in AU
se.dist = opcrad;
se.distAU = cspice_convrt(se.dist,'KM','AU');
% AU in km
AU2km = cspice_convrt(1,'AU','KM');


% Planet's Central Meridian Longitude
% Longitude of the planet facing the Earth at a certain time
if 0,
% Get position of Earth with respect to planet
target   = 'EARTH';
frame    = 'J2000';
obsrvr   = PLANET;
[state,ltime] = cspice_spkezr(target,et,frame,abcorr,obsrvr);
% transformation matrix from J2000 at epoch et-ltime to 
% planet's fixed frame at epoch et
rotate = cspice_pxfrm2('J2000',IAU_PLANET,et-ltime,et);
sysIIIstate = rotate*state(1:3);
[~,CML1,~] = cspice_reclat(sysIIIstate);
fprintf(1,'CML(III)c                = %+9.4f deg\n', CML1*r2d);
[CML2,~,~] = cspice_recpgr(PLANET,sysIIIstate,re,f);
fprintf(1,'CML(III)g                = %+9.4f deg\n', CML2*r2d);
end

% geocentric
CML = opclon;
fprintf(1,'CML(III)c                = %+9.4f deg\n', CML*r2d);
% geographic
CML = opglon;
fprintf(1,'CML(III)g                = %+9.4f deg\n', CML*r2d);

if 0
if abs(opglon*r2d-c2glon(planet,opclon*r2d))>3*eps*r2d,
  abs(opglon*r2d-c2glon(planet,opclon*r2d)),3*eps*r2d
  error('potential issue with c2glon()');
end
end

% Return CML
se.CML = CML*r2d;


% Calculation of the apparent angle between celestial North and the planet's
% rotation axis seen from Earth 

% nSky: normal vector to Earth sky plane pointing from planet to Earth
if 0,
% seposn: position of Earth with respect to planet
nSky = cspice_vhat(seposn);
% matrix to transform from Earth referential to planet's referential
Earth2PlanetRef = cspice_pxfrm2('IAU_EARTH',IAU_PLANET,et,et);
else
% obspos: observer's position relative to the center of the target
nSky = cspice_vhat(obspos);
% matrix to transform from Earth referential to planet's referential
Earth2PlanetRef = cspice_pxfrm2('IAU_EARTH',IAU_PLANET,et,se.trgepc);
end

% Planet's rotation axis 
planetRotAxis = [0;0;1];

% normalised direction of Earth rotation axis 
EarthRotAxis = cspice_vhat(Earth2PlanetRef*[0;0;1]);

% psi is the oriented angle (positive anti-clockwise) between the projections
% of Earth and the planet's rotation axes onto the Earth sky plane 
projPlanetRotAxis = projVecOnPlane(planetRotAxis,nSky);
projEarthRotAxis = projVecOnPlane(EarthRotAxis,nSky);

% cosine and sine of psi in a frame with anti-clockwise orientation
cosa = dot(projEarthRotAxis,projPlanetRotAxis);
sina = dot(cross(projEarthRotAxis,projPlanetRotAxis),nSky);
psi = atan2(sina,cosa);
fprintf(1,'psi(NP)                  = %+9.4f deg\n', psi*r2d);

if 0,
if sina>0, % Angle(projEarthRotAxis,projPlanetRotAxis)>0 psi in [0,pi] 
  psi1 = acos(cosa);
else, % Angle(projEarthRotAxis,projPlanetRotAxis)<0 psi in [-pi,0]
  psi1 = -acos(cosa);
end
fprintf(1,'psi1(NP)                 = %+9.4f deg\n', psi1*r2d);
fprintf(1,'diff                     = %+9.2f deg\n', (psi-psi1)*r2d);
end

% Return psi
se.psi = psi*r2d;

% Transform position of planet's axis to Radial Tangential Normal coordinates
% Set up RTN definitions in planet's coordinates
% R = Sun to planet unit vector
% T = (Omega x R) / | (Omega x R) | where Omega is Sun's spin axis  
% N completes the right-handed triad 

% normalised radial vector from Sun toward planet 
rvec = -cspice_vhat(ssposn);

% get the matrix that transforms position from Sun at epoch from to planet at epoch to 
% For n-vectors from/to Sun2Planet is an array of dimensions (3,3,n).
Sun2Planet = cspice_pxfrm2('IAU_SUN',IAU_PLANET,ss.trgepc,ss.trgepc);

% Sun axis orientation in Sun-centred system
sunaxis = [0;0;1];
% and in frame of planet
sunaxis = Sun2Planet * sunaxis;

% Tangential is perpendicular to radial and sun axis 
tvec = cspice_vhat(cross(sunaxis, rvec));
% Normal is perpendicular to radial and tangential
nvec = cspice_vhat(cross(rvec, tvec));

% Planet's axis orientation in planet-centred system
planetAxis = [0;0;1]; 

% in RTN
planetAxisRTN = [rvec,tvec,nvec]'*planetAxis;
if 0,
planetAxis_r = sum(planetAxis.*rvec);
planetAxis_t = sum(planetAxis.*tvec);
planetAxis_n = sum(planetAxis.*nvec);
end

% get planet's axis / sun direction angular separation
planetAxisSunAng = acos(-1.0*rvec(3));

fprintf(1,'planetAxisSunAng         = %+9.4f deg\n',planetAxisSunAng*r2d);
fprintf(1,'90-ss.lat                = %+9.4f deg\n',90-ss.lat);

fprintf(1,'Earth epoch              = %s\n',cspice_et2utc(et,'C',0));
fprintf(1,'Target epoch             = %s\n',cspice_et2utc(se.trgepc,'C',0));
fprintf(1,'Target epoch             = %s\n',cspice_et2utc(ss.trgepc,'C',0));
fprintf(1,'Sub-Earth rad, lat, lon  = %9.4f, %+9.4f, %+9.4f\n',...
        se.rad,se.lat,se.lon);
fprintf(1,'Sub-Solar rad, lat, lon  = %9.4f, %+9.4f, %+9.4f\n',...
        ss.rad,ss.lat,ss.lon);

% Phase and solar separation parameters
cosd = dot(se.spoint,ss.spoint)/(norm(se.spoint)*norm(ss.spoint));
fprintf(1,'Solar-Earth separation   = %+9.4f deg\n', acosd(cosd));
F = 1/2*(1+cosd);
fprintf(1,'Phase F                  = %9.4f\n', F);

fprintf(1,'Earth-Sun lon difference = %+9.4f deg\n',ss.lon-se.lon);
fprintf(1,'Earth-%s distance%s= %9.4f AU (%.0f km)\n',...
        Planet,char(' '*ones(1,10-length(Planet))),...
				cspice_convrt(se.dist,'KM','AU'),se.dist);
fprintf(1,'Sun-%s distance%s  = %9.4f AU (%.0f km)\n',...
        Planet,char(' '*ones(1,10-length(Planet))),...
				cspice_convrt(ss.dist,'KM','AU'),ss.dist);

%  It's always good form to unload kernels after use,
%  particularly in MATLAB due to data persistence.
cspice_kclear

% Convert planetocentric to planetographic longitude in deg
% i.e. from [-180,180] clockwise to [0,360] clockwise or anti-clockwise
% depending on the planet
function lon = c2glon(planet,lon)
switch planet,
  case {'uranus','moon'},
    lon = mod(lon, 360);
	case {'mars','jupiter','saturn'},
    lon = mod(360 - lon, 360);
	otherwise
	  error('planet longitude not checked...');
end

% Compute unit vector of the projection of x onto the plane
% defined by its normal vector np
function xproj = projVecOnPlane(x,np)
% substract to x the quantity dot(x,np)*np, the component of x along np
xproj = cspice_vhat(x - dot(x,np)*np);

