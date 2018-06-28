function [x,y] = disc(p,n)
% function [x,y] = disc(p,n)
%
% returns coordinates [x,y] of n points on a disc
% i.e. a circle given by parameters p=(xc,yc,r) or
% an ellipse given by parameters p=(xc,yc,a,b,tilt)
% where tilt is the angle of semi-major axis to x-axis 
% in radians unit

%
% $Id: disc.m,v 1.5 2012/04/16 15:45:15 patrick Exp $
%
% Copyright (c) 2011-2012 Patrick Guio <patrick.guio@gmail.com>
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

if ~exist('n','var') | isempty(n),
  n = 50;
end

ts = linspace(0,2*pi,n);

if length(p)==5,
  [x,y] = ellipse(ts,p(:));
elseif length(p)==3,
  [x,y] = circle(ts,p(:));
end


function [x,y] = circle(t,p)

xc = p(1); % x-coordinate of circle center 
yc = p(2); % y-coordinate of circle center
r0 = p(3); % radius

x = xc + r0*cos(t);
y = yc + r0*sin(t);

function [x,y] = ellipse(t,p)

xc = p(1); % x-coordinate of ellipse center 
yc = p(2); % y-coordinate of ellipse center
a  = p(3); % semi-major axis
b  = p(4); % semi-minor axis
t0 = p(5); % tilt angle of semi-major axis to x-axis [rad]

xp = a*cos(t);
yp = b*sin(t);

Q = rot(t0);
x = zeros(size(xp));
y = zeros(size(yp));
for i=1:length(t),
  XY = [xc;yc]+Q*[xp(i);yp(i)];
  x(i) = XY(1);
  y(i) = XY(2);
end

function Q = rot(alpha)

Q = [cos(alpha), -sin(alpha); ...
     sin(alpha), cos(alpha)];

