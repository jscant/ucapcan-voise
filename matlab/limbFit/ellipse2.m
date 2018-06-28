function r=ellipse2(xy,p)
% function r=ellipse2(xy,p)

%
% $Id: ellipse2.m,v 1.4 2015/12/04 15:56:04 patrick Exp $
%
% Copyright (c) 2010-2015 Patrick Guio <patrick.guio@gmail.com>
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

global verbose

if ~isempty(verbose) & length(verbose)>2 & verbose(3),
  fprintf(1,'calling ellipse2 (xc,yc,a,b,t0)=(%.1f,%.1f,%.1f,%.1f,%.0f)\n',...
          p(1:5));
end

xc = p(1); % x-coordinate of ellipse center 
yc = p(2); % y-coordinate of ellipse center
a  = p(3); % semi-major axis
b  = p(4); % semi-minor axis
t0 = p(5); % tilt angle of semi-major axis to x-axis [rad]
ti = p(6:end); % angles

ni = length(xy);
m = fix(ni/2);

xi = xy(1:m);
yi = xy(m+1:ni);

xp = a*cos(ti);
yp = b*sin(ti);

Q = rot(t0);
x = zeros(size(xi));
y = zeros(size(xi));
for i=1:m,
  XY = [xc;yc]+Q*[xp(i);yp(i)];
	x(i) = XY(1);
	y(i) = XY(2);
end

r = [x;y];

if 0
plot(xi,yi,'ro',x,y,'bo')
drawnow
end

function Q = rot(alpha)

Q = [cos(alpha), -sin(alpha); ...
     sin(alpha), cos(alpha)];


