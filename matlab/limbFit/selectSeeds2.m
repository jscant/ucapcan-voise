function fit = selectSeeds2(fit,Sx,Sy,Sls)
% function fit = selectSeeds2(fit,Sx,Sy,Sls)

%
% $Id: selectSeeds2.m,v 1.2 2015/12/04 15:42:12 patrick Exp $
%
% Copyright (c) 2015 Patrick Guio <patrick.guio@gmail.com>
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

% eccentricity parametrisation of two ellipses to be used with @ellipse4

% first equation
a{1} = p(3);
e{1} = p(4);
p(4) = a{1} * sqrt(1-e{1}^2);
b{1} = p(4);

% second equation
a{2} = p(6);
e{2} = p(7);
p(7) = a{2} * sqrt(1-e{2}^2);
b{2} = p(7);

Sx    = fit.Sx;
Sy    = fit.Sy;
LS    = fit.Sls;

LSmax = fit.LSmax;
Rmin  = fit.Rmin;
Rmax  = fit.Rmax;

% find seeds with specification scale length and position
xc   = p(1);
yc   = p(2);
t0{1} = p(5);
t0{2} = p(8);

% for the two functions
for i=1:2,

  % unit vector along major axis
  xa = cosd(t0{i});
  ya = sind(t0{i});

  % rotate seeds along specified major axis
  X =  xa*(Sx-xc) + ya*(Sy-yc);
  Y = -ya*(Sx-xc) + xa*(Sy-yc);

  % canonical form of ellipse (X/a)^2+(Y/b)^2=1
  ellipseEq = X.^2/a{i}^2+Y.^2/b{i}^2;

  % selection of seeds criteria 
  %iSelect = find(Sls <= LSmax & ellipseEq > Rmin^2 & ellipseEq < Rmax^2);
  iSelect{i} = (Sls <= LSmax & ellipseEq > Rmin^2 & ellipseEq < Rmax^2);
  fprintf(1,'Total number of seeds: %d\n', length(Sls));
  fprintf(1,'Number Seeds on limb : %d\n', length(Sls(find(iSelect{i}))))

  % finally angle selection
  % atan2 is the four quadrant arctangent -pi <= ATAN2(Y,X) <= pi.
  T = 180/pi*atan2(Y, X);

  if iscell(fit.Tlim) & length(fit.Tlim)>=i,
    Tlim = fit.Tlim{i};
    for j=1:length(Tlim),
	    iSelect{i} = iSelect{i} & (T < Tlim{j}(1) | T > Tlim{j}(2) );
      fprintf(1,'Number Seeds on limb : %d\n', length(Sls(find(iSelect{i}))));
	  end
	end

end

% embed selected seeds in fit structure
fit.iSelect = iSelect{1};
for i=2:length(iSelect),
  fit.iSelect = fit.iSelect | iSelect{i};
end
fit.iSelect = find(fit.iSelect);

fit.iModels = zeros(size(fit.iSelect));
for i=1:length(fit.iSelect),
  if iSelect{1}(fit.iSelect(i)),
	  fit.iModels(i) = 1;
	elseif iSelect{2}(fit.iSelect(i)),
	  fit.iModels(i) = 2;
	end
end

if 1,
  p=pause; pause on
  plot(Sx(iSelect{1}),Sy(iSelect{1}),'o',...
	     Sx(iSelect{2}),Sy(iSelect{2}),'x');
	fprintf(1,'press a key to continue...\n'); pause
	pause(p)
end
