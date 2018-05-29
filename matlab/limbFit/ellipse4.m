function r=ellipse4(xy,p)
% function r=ellipse4(xy,p)

%
% $Id: ellipse4.m,v 1.2 2015/12/04 15:56:04 patrick Exp $
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

global verbose iModels

if ~isempty(verbose) & length(verbose)>2 & verbose(3),
  fprintf(1,'calling ellipse4 (xc,yc,a1,e1,t1,a2,e2,t2)=(%.1f,%.1f,%.1f,%.1f,%.0f,%.1f,%.1f,%.0f)\n',...
          p(1:8));
end

xc = p(1); % x-coordinate of ellipse center 
yc = p(2); % y-coordinate of ellipse center
a1  = p(3); % semi-major axis
e1  = p(4); % eccentricity
t1 = p(5); % tilt angle of semi-major axis to x-axis [rad]
a2  = p(6); % semi-major axis
e2  = p(7); % eccentricity
t2 = p(8); % tilt angle of semi-major axis to x-axis [rad]
ti = p(9:end); % angles [rad]

ni = length(xy);
% number of points
m = fix(ni/2);

% points to fit
xi = xy(1:m);
yi = xy(m+1:ni);


x = zeros(size(xi));
y = zeros(size(yi));

% first ellipse
I1 = find(iModels==1);
xp = a1 * cos(ti(I1));
yp = a1 * sqrt(1-e1^2) * sin(ti(I1));
Q = rot(t1);
x1 = zeros(size(xp));
y1 = zeros(size(xp));
for i=1:length(xp),
  XY = [xc;yc]+Q*[xp(i);yp(i)];
	x1(i) = XY(1);
	y1(i) = XY(2);
end
x(I1) = x1;
y(I1) = y1;

if 0 & ~isempty(verbose) & length(verbose)>2 & verbose(3),
p = pause; pause on
plot(xi(I1),yi(I1),'o',x1,y1,'x')
drawnow, fprintf(1,'press return\n'), pause
pause(p);
end


% second ellipse
I2 = find(iModels==2);
xp = a2 * cos(ti(I2));
yp = a2 * sqrt(1-e2^2) * sin(ti(I2));
Q = rot(t2);
x2 = zeros(size(xp));
y2 = zeros(size(xp));
for i=1:length(xp),
  XY = [xc;yc]+Q*[xp(i);yp(i)];
	x2(i) = XY(1);
	y2(i) = XY(2);
end
x(I2) = x2;
y(I2) = y2;


if 0 & ~isempty(verbose) & length(verbose)>2 & verbose(3),
p = pause; pause on
plot(xi(I2),yi(I2),'o',x(I2),y(I2),'x')
fprintf(1,'press a key to continue...\n'); pause
pause(p);
end

r = [x;y];


if ~isempty(verbose) & length(verbose)>2 & verbose(3),
p = pause; pause on
plot(xi(I1),yi(I1),'o',x(I1),y(I1),'x',...
     xi(I2),yi(I2),'o',x(I2),y(I2),'x')
fprintf(1,'press a key to continue...\n'); pause
pause(p);
end

function Q = rot(alpha)

Q = [cos(alpha), -sin(alpha); ...
     sin(alpha), cos(alpha)];


