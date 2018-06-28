function [ra,dec] = getHSTabs2relRadec(HST,ra,dec)
% function [ra,dec] = getHSTabs2relRadec(HST,ra,dec)
%
% Transform absolute ra/dec in degree into relative ra/dec with respect
% to reference pixel in arcsec
% HST is a structure containing necessary HST fits header information 
% provided by function getHSTInfo()

%
% $Id: getHSTabs2relRadec.m,v 1.1 2012/06/13 14:14:08 patrick Exp $
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

% reference pixel ra/dec coordinates (deg)
rpra  = HST.CRVAL1;
rpdec = HST.CRVAL2;

% scale factor from deg to arcsec
s   = 3600; 

ra  = s*(ra - rpra);
dec = s*(dec - rpdec);

