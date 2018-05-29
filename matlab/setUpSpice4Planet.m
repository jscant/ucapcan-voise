function [planet] = setUpSpice4Planet(HST)
% function [planet] = setUpSpice4Planet(HST)

%
% $Id: setUpSpice4Planet.m,v 1.6 2017/11/22 16:28:07 patrick Exp $
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

isJup = regexp(HST.TARGNAME, 'JUP|PJ..-V..');
isSat = regexp(HST.TARGNAME, 'SAT');

if ~isempty(isJup) & isJup,
  planet.name = 'jupiter';
elseif ~isempty(isSat) & isSat,
  planet.name = 'saturn';
else
  planet.name = lower(HST.TARGNAME);
end

verbose = 1;
loadPlanetSpiceKernels(planet.name,verbose);

return

% generic kernel path
spiceKernelsPath = getSpiceGenericKernelsPath();

% Load a leapseconds kernel.
% ftp://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/
cspice_furnsh([spiceKernelsPath 'naif0012.tls']);

% Load planetary ephemeris 
% ftp://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/planets/
cspice_furnsh([spiceKernelsPath 'de430.bsp']);

% Load satellite ephemeris 
% ftp://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/
switch planet.name,
  case 'jupiter'
    cspice_furnsh([spiceKernelsPath 'jup329.bsp']);
  case 'saturn'
    cspice_furnsh([spiceKernelsPath 'sat378.bsp']);
		cspice_furnsh([spiceKernelsPath 'cpck04Mar2015.tpc']);
  case 'uranus'
    cspice_furnsh([spiceKernelsPath 'ura112.bsp']);
end

% Load orientation data for planets, natural 
% satellites, the Sun, and selected asteroids
% ftp://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/
cspice_furnsh([spiceKernelsPath 'pck00010.tpc']);

% conversion factors
degPerRad = cspice_dpr;
radPerDeg = cspice_rpd;
radPerArcsec = radPerDeg/3600;
arcsecPerRad = degPerRad*3600;
