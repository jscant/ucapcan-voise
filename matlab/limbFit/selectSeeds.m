function fit = selectSeeds(fit,Sx,Sy,Sls)
% function fit = selectSeeds(fit,Sx,Sy,Sls)

%
% $Id: selectSeeds.m,v 1.11 2015/09/13 20:20:19 patrick Exp $
%
% Copyright (c) 2009-2012 Patrick Guio <patrick.guio@gmail.com>
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
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.


p     = fit.p0;

% eccentricity parametrisation
if strcmp(func2str(fit.model{1}),'ellipse3'),
  a = p(3);
  e = p(4);
  p(4) = a * sqrt(1-e^2);
end

Sx    = fit.Sx;
Sy    = fit.Sy;
LS    = fit.Sls;

LSmax = fit.LSmax;
Rmin  = fit.Rmin;
Rmax  = fit.Rmax;

% find seeds with specification scale length and position
xc   = p(1);
yc   = p(2);
a    = p(3);
if length(p) == 3,
  b  = a;
  t0 = 0;
elseif length(p) == 5,
  b  = p(4);
  t0 = p(5);
end

% unit vector along major axis
xa = cosd(t0);
ya = sind(t0);

% rotate seeds along specified major axis
X =  xa*(Sx-xc) + ya*(Sy-yc);
Y = -ya*(Sx-xc) + xa*(Sy-yc);

% canonical form of ellipse (X/a)^2+(Y/b)^2=1
ellipseEq = X.^2/a^2+Y.^2/b^2;

% selection of seeds criteria 
%iSelect = find(Sls <= LSmax & ellipseEq > Rmin^2 & ellipseEq < Rmax^2);
iSelect = (Sls <= LSmax & ellipseEq > Rmin^2 & ellipseEq < Rmax^2);
fprintf(1,'Total number of seeds: %d\n', length(Sls));
fprintf(1,'Number Seeds on limb : %d\n', length(Sls(find(iSelect))))

% finally angle selection
% atan2 is the four quadrant arctangent -pi <= ATAN2(Y,X) <= pi.
T = 180/pi*atan2(Y, X);

if ~isempty(fit.Tlim),
  for i=1:length(fit.Tlim),
	  iSelect = iSelect & (T < fit.Tlim{i}(1) | T > fit.Tlim{i}(2) );
    fprintf(1,'Number Seeds on limb : %d\n', length(Sls(find(iSelect))));
	end
end

% embed selected seeds in fit structure
fit.iSelect = find(iSelect);

