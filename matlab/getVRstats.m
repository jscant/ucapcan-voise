function [S,xc,yc,md2s,md2c] = getVDstats(VD, params, sk)
% function [S,xc,yc,md2s,md2c] = getVDstats(VD, params, sk)

%
% $Id: getVRstats.m,v 1.3 2012/04/16 16:54:27 patrick Exp $
%
% Copyright (c) 2010-2012 Patrick Guio <patrick.guio@gmail.com>
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

% Calculate equivalent scale length from VD as sqrt(S)
[imls, Sls] = getVDOp(VD, params.W, @(x) sqrt(length(x)));

if ~exist('sk') | isempty(sk),
  sk = [1:length(VD.Sk)]';
end

% surface area
S = zeros(size(sk));
% x-coordinate of centroid
xc = zeros(size(sk));
% y-coordinate of centroid
yc = zeros(size(sk));
% mean distance to Voronoi seed
md2s = zeros(size(sk));
% mean distance to centroid
md2c = zeros(size(sk));

is = 1;
for k = VD.Sk(sk)',

  % find out closure of Voronoi Region associated to seed k
	[ii, jj, ij] = getVRclosure(VD, k, VD.Nk{k});

	x = jj;
	y = ii;

	S(is) = length(ii);
  sx(is) = mean(x);
	sy(is) = mean(y);
  md2s(is) = sqrt(sum((x-VD.Sx(k)).^2+(y-VD.Sy(k)).^2)/S(is));
  md2c(is) = sqrt(sum((x-sx(is)).^2+(y-sy(is)).^2)/S(is));

if 0,
  fprintf(1,'Sls %.2f S %.0f sx %.2f sy %.2f md2s %.2f md2c %.2f\n',...
	        Sls(is),S(is),sx(is),sy(is),md2s(is),md2c(is));
end
  is = is+1;

end
