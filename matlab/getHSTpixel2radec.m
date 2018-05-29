function [ra, dec] = getHSTpixel2radec(HST,px,py)
% function [ra, dec] = getHSTpixel2radec(HST,px,py)

%
% $Id: getHSTpixel2radec.m,v 1.2 2012/06/12 11:00:05 patrick Exp $
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

% reference pixel image coordinates 
rpx = HST.CRPIX1;
rpy = HST.CRPIX2;

% reference pixel ra/dec coordinates (deg)
rpra  = HST.CRVAL1;
rpdec = HST.CRVAL2;

% matrix to transform from pixel to world (ra/dec) coordinates
CD = HST.CD;

% pixel (lower left is 1,1) to world (deg) coordinates 
ra  = CD(1,1)*(px-rpx) + CD(1,2)*(py-rpy) + rpra;
dec = CD(2,1)*(px-rpx) + CD(2,2)*(py-rpy) + rpdec;

