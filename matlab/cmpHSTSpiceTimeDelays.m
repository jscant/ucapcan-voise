function cmpHSTSpiceTimeDelays(filename)
% function cmpHSTSpiceTimeDelays(filename)

%
% $Id: cmpHSTSpiceTimeDelays.m,v 1.5 2012/06/13 14:14:56 patrick Exp $
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

params = getDefaultVOISEParams;
params.iFile = filename;

% get HST parameters if available
params = getHSTInfo(params);

HST = params.HST;

planet = setUpSpice4Planet(HST);

% conversion factors
degPerRad = cspice_dpr;
radPerDeg = cspice_rpd;
radPerArcsec = radPerDeg/3600;
arcsecPerRad = degPerRad*3600;

% Convert string date to double precision 
et = cspice_str2et([HST.TDATEOBS ' ' HST.TTIMEOBS]);

% get planet ra,dec in J2000 frame for difference aberration corrections

target   = planet.name;
times    = et + [0, HST.EXPTIME]; % start and end exposure times
frame    = 'J2000'; % Earth mean equator, dynamical equinox of J2000
observer = 'EARTH';

% aberration corrections for "reception" case (photons depart from the
% target's location at the light-time corrected epoch et-lt and *arrive* at the
% observer's location at 'et'
abcorr = { ...
  'NONE', ... % No correction
  'LT', ... % Correct for one-way light time
	'LT+S', ... % Correct for one-way light time and stellar aberration
	'CN', ... % Converged Newtonian light time correction
	'CN+S' ... % Converged Newtonian light time and stellar aberration
	};

range = zeros(length(times), length(abcorr));
lt = zeros(length(times), length(abcorr));
ra = zeros(length(times), length(abcorr));
dec = zeros(length(times), length(abcorr));

for i = 1:length(abcorr),
  [state, lt(:,i)] = cspice_spkezr(target, times, frame, abcorr{i}, observer);
  [range(:,i),ra(:,i),dec(:,i)] = cspice_recrad(state(1:3,:));
end

% rad to deg
ra = ra*degPerRad;
dec = dec*degPerRad;

%fprintf(1,'planet    ra, dec = %.4f,%.4f : %.4f,%.4f\n',[ra(:)';dec(:)']);
for i = 1:length(abcorr),
  fprintf(1,'pc ra, dec (deg)  = %12.6f,%12.6f : %12.6f,%12.6f (%s)\n',...
	[ra(:,i),dec(:,i)]', abcorr{i});
end

% remove converged corrections
abcorr = {abcorr{1:3}};
range = range(:,1:3);
lt = lt(:,1:3);
ra = ra(:,1:3);
dec = dec(:,1:3);

info = fitsinfo(params.iFile);

if ~isfield(info,'Image'),
  img = squeeze(fitsread(params.iFile));
else
  img = squeeze(fitsread(params.iFile,'image'));
end
[nr, nc] = size(img);

% pixel coordinates (indices j)
[Xj,Yj] = meshgrid(1:nc, 1:nr);

% ref pixel
rpx = HST.CRPIX1;
rpy = HST.CRPIX2;
% ref ra/dec
rpra = HST.CRVAL1;
rpdec = HST.CRVAL2;

% pixel coordinates to world coordinates (ra/dec) (indices i)
[Xi,Yi] = getHSTpixel2radec(HST,Xj,Yj);

% planet world coordinates (ra/dec) to pixel coordinates
[pxc,pyc] = getHSTradec2pixel(HST,ra,dec);

for i = 1:length(abcorr),
  fprintf(1,'pc  x, y (pixel)  = %12.6f,%12.6f : %12.6f,%12.6f (%s)\n',...
	[pxc(:,i),pyc(:,i)]', abcorr{i});
end


close all
figure
pcolor(Xj,Yj,log10(abs(img))); shading flat;
hold on
plot(rpx,rpy,'ko','markersize',5);
plot(pxc,pyc,'-kx','markersize',5);
opts = {'fontsize',9,'fontweight','light','color','green'};
for i = 1:length(abcorr),
  text(pxc(1,i), pyc(1,i),['S(' abcorr{i} ')'],opts{:})
  text(pxc(2,i), pyc(2,i),'E',opts{:})
end
hold off
axis auto
axis equal

figure
if 1,
  % convert to arcsec and set relative ra/dec to ref pix
	[Xi,Yi] = getHSTabs2relRadec(HST,Xi,Yi);
	[rpra,rpdec] = getHSTabs2relRadec(HST,rpra,rpdec);
	[ra,dec] = getHSTabs2relRadec(HST,ra,dec);
	xlbl = 'ra/ref. pixel [arcsec]';
	ylbl = 'dec/ref.pixel [arcsec]';
else
  % absolute ra/dec in deg
	xlbl = 'ra [deg]';
	ylbl = 'dec [deg]';
end

pcolor(Xi,Yi,log10(abs(img))); shading flat;
hold on
axis auto
plot(rpra,rpdec,'bo','markersize',5)
plot(ra,dec,'-bx','markersize',5)
for i = 1:length(abcorr),
  text(ra(1,i), dec(1,i),['S(' abcorr{i} ')'],opts{:})
  text(ra(2,i), dec(2,i),'E',opts{:})
end
hold off
axis auto
axis equal
xlabel(xlbl);
ylabel(ylbl);


%  particularly in MATLAB due to data persistence.
cspice_kclear

