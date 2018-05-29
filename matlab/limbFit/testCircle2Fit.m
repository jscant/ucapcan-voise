function testCircle2Fit(ns,pc,p,p0,dp)
% function testCircle2Fit(ns,pc,p,p0,dp)
% 
% Try for example
% testCircle2Fit
% testCircle2Fit(100,0.2,[3.5,-8.5,250],[-20,10,285],ones(1,3))
%


%
% $Id: testCircle2Fit.m,v 1.3 2012/04/16 15:45:15 patrick Exp $
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
	pc = 0.05;
	p = [3.5,-8.5,250];
	p0 = [-10,10,285];
	% fit all parameters
	dp = ones(1,3);
  testDriver(ns, pc, p, p0, dp);
elseif nargin==5,
  testDriver(ns, pc, p, p0, dp);
end

pause(pstate)

function testDriver(ns,pc,p,p0,dp)

global verbose
verbose=[0 1 0];

Xc = p(1);
Yc = p(2);
r  = p(3);

% init seed of Mersenne-Twister RNG
rand('twister',10);

t = 360*rand(1,ns);

Sx0 = Xc + r*cosd(t);
Sy0 = Yc + r*sind(t);

Ti = t*pi/180;

Sx = Xc + r*(1+pc*(0.5-rand(1,ns))).*cosd(t);
Sy = Yc + r*(1+pc*(0.5-rand(1,ns))).*sind(t);

%plot(Sx0,Sy0,'x',Sx,Sy,'o');

fprintf(1,'seeds # %d,  pc %f\n', ns, pc);

LSS = sqrt((Sx0-Sx).^2+(Sy0-Sy).^2);
fprintf(1,'LSS min %f max %f\n', [min(LSS), max(LSS)]);

fp = fitCircle2([],[],LSS,Sx,Sy,[1:length(LSS)],p0);

return

fprintf(1,'exact  Xc(%.1f,%.1f) R=%.1f\n', p([1:3]));
fprintf(1,'guess  Xc(%.1f,%.1f) R=%.1f\n', p0([1:3]));
fprintf(1,'fitted Xc(%.1f,%.1f) R=%.1f\n', fp([1:3]));

hold on
plot(Sx0,Sy0,'ok');
hold off
h = get(gca,'children');
legend(h([1 2 4 3]),'data','data+noise','initial','fitted')

axis equal

% test

[xc,yc,R,a] = circfit(Sx,Sy);
fprintf(1,'circfit Xc(%.1f,%.1f) R=%.1f\n', xc,yc,R);


Par = CircleFitByTaubin([Sx(:),Sy(:)]);
fprintf(1,'circfit Xc(%.1f,%.1f) R=%.1f\n', Par);

t = sort(t);
x1 = xc + R*cosd(t);
y1 = yc + R*sind(t);

xc = Par(1); yc = Par(2); R = Par(3);
x2 = xc + R*cosd(t);
y2 = yc + R*sind(t);

hold on
plot(x1,y1,'o-',x2,y2,'o-');
hold off

