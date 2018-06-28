function p = getEllipseParams()
% function p = getEllipseParams()

%
% $Id: getEllipseParams.m,v 1.4 2012/04/16 15:45:15 patrick Exp $
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

fprintf(1,'\nSelect approximate disc centre and press mouse button\n');
[xc, yc] = ginput(1);

fprintf(1,'xc = %.1f yc = %.1f\n', xc, yc);

fprintf(1,'\nSelect approximate semi-major axis and press mouse button\n');
[xa, ya] = ginput(1);

% semi-major axis such that ax>0 
ax = sign(xa-xc)*(xa-xc);
ay = sign(xa-xc)*(ya-yc);
a  = sqrt(ax^2+ay^2);
% tilt angle between major axis and x-axis is in interval [-90,90] deg
ta = 180/pi*atan2(ay,ax);

fprintf(1,'a = %.1f t0 = %.0f\n', a, ta);

fprintf(1,'\nSelect approximate semi-minor axis and press mouse button\n');
[xb, yb] = ginput(1);

% semi-mino axis such that bx>0 
bx = sign(xb-xc)*(xb-xc);
by = sign(xb-xc)*(yb-yc);
b  = sqrt(bx^2+by^2);
% cross product between semi-major and semi-minor axis in 
aCrossb = ax*by-ay*bx;
% tilt angle between minor axis and x-axis is in interval [-90,90] deg
% if cross product > 0 subtract 90 deg
% if cross product < 0 add      90 deg
tb = 180/pi*atan2(by,bx)-90*sign(aCrossb);

fprintf(1,'b = %.1f t0 = %.0f\n', b, tb);

t0 = 0.5*(ta+tb);

p = [xc,yc,a,b,t0];

