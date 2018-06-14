function [rings,ringsSpecs] = getPlanetRings(planetName)
% function [rings,ringsSpecs] = getPlanetRings(planetName)

%
% $Id: getPlanetRings.m,v 1.1 2018/06/14 11:56:38 patrick Exp $
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


% load SPICE kernels
loadPlanetSpiceKernels(planetName);

switch planetName

  case 'jupiter',
	  % https://en.wikipedia.org/wiki/Rings_of_Jupiter
	  % Halo ring, Main ring, Amalthea gossamer ring, Thebe gossamer ring
		rings = {'Halo Ring','Main Ring','Amalthea Gossamer Ring','Thebe Gossamer Ring'};
		ringsSpecs = [92000,122500;122500,129000;129000,182000;129000,226000];
  case 'saturn',
	  % https://en.wikipedia.org/wiki/Rings_of_Saturn
	  % A Ring, Encke Gap, Cassini Division, B Ring
		rings = {'RING1','RING1_1','RING2','RING3'};
		rings = {'A Ring','Encke Gap','Cassini Division','B Ring'};
		ringsSpecs = [122170,136780;133405,133730;11758,122170;92000,117580];
	case 'uranus'
	  % https://en.wikipedia.org/wiki/Rings_of_Uranus
    % Nu Ring, Mu Ring
		rings = {'Nu Ring','Mu Ring'};
		ringsSpecs = [66100,69900;86000,103000];
end

return

ringSpecs = zeros(5,length(rings));
% Ring geometry is defined in the form of one set of R1, R2, Z1, Z2, OD where
% R1 and R2 are inner and outer radii of the ring (in km)
% Z1 and Z2 are the vertical heights of the ring at R1 and R2 (also in km,
% equal to one-half of the total thickness of the ring)
% OD is the average optical depth of the ring sub-segment/gap across R1 to R2.
for i=1:length(rings),
  ringSpecs(:,i) = cspice_bodvrd(planetName,rings{i},5);
  ringSpecs(1:2,i)
end


%  It's always good form to unload kernels after use,
%  particularly in MATLAB due to data persistence.
cspice_kclear


