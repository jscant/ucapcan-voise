function [a,b,e,f] = getPlanetGeometry(planetName)
% function [a,b,e,f] = getPlanetGeometry(planetName)

%
% $Id: getPlanetGeometry.m,v 1.4 2018/06/14 11:56:38 patrick Exp $
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


% load necessary kernels
loadPlanetSpiceKernels('standard');

% For each body, three radii are listed:  The first number is
% the largest equatorial radius (the length of the semi-axis
% containing the prime meridian), the second number is the smaller
% equatorial radius, and the third is the polar radius.
radii = cspice_bodvrd(planetName,'RADII',3);

% major axis
a = radii(1);
% minor axis
b = radii(3);
% eccentricity
e = sqrt(a^2-b^2)/a;
% flattening
f = (a-b)/a;

%  It's always good form to unload kernels after use,
%  particularly in MATLAB due to data persistence.
cspice_kclear


