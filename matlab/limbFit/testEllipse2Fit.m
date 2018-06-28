function testEllipse2Fit(ns,pc,p,p0,dp)
% function testEllipse2Fit(ns,pc,p,p0,dp)
%
% Try for example
% testEllipse2Fit
% testEllipse2Fit(500,0.2,[3.5,-8.5,340,250,30],[3,-8,340,250,60],ones(1,5))
%

%
% $Id: testEllipse2Fit.m,v 1.3 2012/04/16 15:45:15 patrick Exp $
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

pstate = pause('query');
pause('off')


if nargin==0,
  ns = 500;
	pc = 0.1,
	p = [3.5,-8.5,340,250,0];
	p0 = [-10,10,285,295,0];
  % fit all parameters
  dp = ones(1,5);
  testDriver(ns, pc, p, p0, dp);
elseif nargin==5
  testDriver(ns, pc, p, p0, dp);
end

pause(pstate)

function testDriver(ns,pc,p,p0,dp)

global verbose
verbose=[0 1 0];

Xc = p(1);
Yc = p(2);
a  = p(3);
b  = p(4);
t0 = p(5);

% init seed of Mersenne-Twister RNG
rand('twister',10);

t = 360*rand(1,ns);

Sx0 = Xc + a*cosd(t)*cosd(t0) - b*sind(t)*sind(t0);
Sy0 = Yc + a*cosd(t)*sind(t0) + b*sind(t)*cosd(t0);

Ti = t*pi/180;

Sx = Xc + a*(1+pc*(0.5-rand(1,ns))).*cosd(t)*cosd(t0)-...
          b*(1+pc*(0.5-rand(1,ns))).*sind(t)*sind(t0);
Sy = Yc + a*(1+pc*(0.5-rand(1,ns))).*cosd(t)*sind(t0)+...
          b*(1+pc*(0.5-rand(1,ns))).*sind(t)*cosd(t0);

%plot(Sx0,Sy0,'x',Sx,Sy,'o');

fprintf(1,'seeds # %d,  pc %f\n', ns, pc);

LSS = sqrt(0.5*((Sx0-Sx).^2+(Sy0-Sy).^2));
LSS = mean(sqrt(((Sx0-Sx).^2+(Sy0-Sy).^2)))*ones(size(Sx));
fprintf(1,'LSS min %f max %f\n', [min(LSS), max(LSS)]);

if isempty(p0),
  s = fit_ellipse(Sx,Sy,gca);
  p0 = [s.X0_in, s.Y0_in, s.long_axis/2, s.short_axis/2, -s.phi*180/pi];
end

fp = fitEllipse2([],[],LSS,Sx,Sy,[1:length(LSS)],p0,dp);

return

fprintf(1,'exact  Xc(%.1f,%.1f) a=%.1f b=%.1f inclination=%.0f\n', p([1:5]));
fprintf(1,'guess  Xc(%.1f,%.1f) a=%.1f b=%.1f inclination=%.0f\n', p0([1:5]));
fprintf(1,'fitted Xc(%.1f,%.1f) a=%.1f b=%.1f inclination=%.0f\n', fp([1:5]));

hold on
plot(Sx0,Sy0,'ok');
hold off
h = get(gca,'children');
legend(h([1 2 4 3]),'data','data+noise','initial','fitted')

axis equal

% test

p = ellipse_fit(Sx, Sy);
fprintf(1,'ellipse_fit Xc(%.1f,%.1f) a=%.1f b=%.1f inclination=%.0f\n', p);
xc = p(1); yc = p(2); a = p(3); b = p(4); t0 = p(5);

t = sort(t);

x1 = xc + a*cosd(t)*cosd(t0) - b*sind(t)*sind(t0);
y1 = yc + a*cosd(t)*sind(t0) + b*sind(t)*cosd(t0);

[A,p] = EllipseFitByTaubin([Sx(:),Sy(:)]);
fprintf(1,'EllipseFitByTaubin Xc(%.1f,%.1f) a=%.1f b=%.1f inclination=%.0f\n', p);
xc = p(1); yc = p(2); a = p(3); b = p(4); t0 = p(5);


x2 = xc + a*cosd(t)*cosd(t0) - b*sind(t)*sind(t0);
y2 = yc + a*cosd(t)*sind(t0) + b*sind(t)*cosd(t0);


s = fit_ellipse(Sx,Sy,gca);
p = [s.X0_in, s.Y0_in, s.long_axis/2, s.short_axis/2, -s.phi*180/pi];
fprintf(1,'fit_ellipse Xc(%.1f,%.1f) a=%.1f b=%.1f inclination=%.0f\n', p);
xc = p(1); yc = p(2); a = p(3); b = p(4); t0 = p(5);

x3 = xc + a*cosd(t)*cosd(t0) - b*sind(t)*sind(t0);
y3 = yc + a*cosd(t)*sind(t0) + b*sind(t)*cosd(t0);

[A,p] = EllipseDirectFit([Sx(:),Sy(:)]);
fprintf(1,'EllipseDirectFit Xc(%.1f,%.1f) a=%.1f b=%.1f inclination=%.0f\n', p);
xc = p(1); yc = p(2); a = p(3); b = p(4); t0 = p(5);

x4 = xc + a*cosd(t)*cosd(t0) - b*sind(t)*sind(t0);
y4 = yc + a*cosd(t)*sind(t0) + b*sind(t)*cosd(t0);


hold on
he = plot(x1,y1,'o-',x2,y2,'o-',x3,y3,'o-',x4,y4,'o-');
hold off
[h([1 2 4 3]); he]
legend([h([1 2 4 3]); he], 'data','data+noise','initial','fitted',...
       'ellipse\_fit','EllipseFitByTaubin','fit\_ellipse','EllipseDirectFit');


