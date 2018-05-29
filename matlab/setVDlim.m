function VDlim = setVDlim(nr,nc,clipping)
% function VDlim = setVDlim(nr,nc,clipping)
%
% clipping is defined as percentage of the image size from each edge 
% (thus in the range 0 to 50) and is given as a vector following the
% convention [left,right,bottom,top]
% default if not provided is no clipping [left,right,bottom,top]=[0,0,0,0]

%
% $Id: setVDlim.m,v 1.1 2015/02/13 12:22:03 patrick Exp $
%
% Copyright (c) 2015 Patrick Guio <patrick.guio@gmail.com>
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

if ~exist('clipping','var') || isempty(clipping),
  % default no clipping 
	clipping = [0, 0, 0, 0];
end
pc = clipping/100;

% seeds are allowed on the edges of image
xm = floor(1 + (nc-1) * pc(1));
xM = ceil(nc - (nc-1) * pc(2));
ym = floor(1 + (nr-1) * pc(3));
yM = ceil(nr - (nr-1) * pc(4));

%fprintf(1,'(xm, xM, ym, yM) = (%d, %d, %d, %d)\n',xm,xM,ym,yM);

% initialise VD seed limit structure
VDlim.xm = xm;
VDlim.xM = xM;
VDlim.ym = ym;
VDlim.yM = yM;


