function S = boardSeeds(nr,nc,ns,VDlim)
% function S = boardSeeds(nr,nc,ns,VDlim)
% 
% ns = [nsx, nsy] and total is nsx * nsy

%
% $Id: boardSeeds.m,v 1.8 2015/02/14 14:53:21 patrick Exp $
%
% Copyright (c) 2008-2012 Patrick Guio <patrick.guio@gmail.com>
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

xm = VDlim.xm;
xM = VDlim.xM;
ym = VDlim.ym;
yM = VDlim.yM;

if length(ns) == 1,
  ns = ns*ones(2,1);
end
nsx = ns(1);
nsy = ns(2);

% uniform tesselation over regular mesh
xi = round(linspace(xm, xM, 2*nsx));
yi = round(linspace(ym, yM, 2*nsy));

[xo, yo] = meshgrid(xi([1:2:end]),yi([1:2:end]));
[xe, ye] = meshgrid(xi([2:2:end]),yi([2:2:end]));

x = [xo(:);xe(:)];
y = [yo(:);ye(:)];

% initialise array S(ns,2) 
% seed s has coordinates (x,y) = S(s, 1:2) 
S = [x(:), y(:)];

