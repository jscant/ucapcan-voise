function gander94fig4
% function gander94fig4
%
% figure 3.3 from Gander et al., 1994

%
% $Id: gander94fig4.m,v 1.3 2012/04/16 15:45:15 patrick Exp $
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

% eq 3.7 from Gander et al., 1994
x = [1, 2, 5, 7, 9, 3, 6, 8]';
y = [7, 6, 8, 7, 5, 7, 2, 4]';


[A1,p1] = EllipseDirectFit([x,y]);
fprintf(1,'z=(%.4f,%.4f) a=%.4f b=%.4f alpha=%.4f\n', p1(1:5));
v1 = solveellipse(A1);
[x1,y1] = ellipse(p1);
v1 = v1([3,4,1,2,5])';
fprintf(1,'z=(%.4f,%.4f) a=%.4f b=%.4f alpha=%.4f\n', v1(1:5));
%[x1,y1] = ellipse(v1);

[A2,p2] = EllipseFitByTaubin([x,y]);
fprintf(1,'z=(%.4f,%.4f) a=%.4f b=%.4f alpha=%.4f\n', p2(1:5));
v2 = solveellipse(A2);
[x2,y2] = ellipse(p2);
v2 = v2([3,4,1,2,5])';
%fprintf(1,'z=(%.4f,%.4f) a=%.4f b=%.4f alpha=%.4f\n', v2(1:5));
%[x2,y2] = ellipse(v2);

xy = [x;y];
p0 = [p1(1:5),atan2(y-p1(2),x-p1(1))']; 
p0 = [p2(1:5),atan2(y-p2(2),x-p2(1))']; 
dp=[ones(1,5), ones(1,length(x))];
dp = ones(size(dp));
w = ones(size(xy));
fracprec=[zeros(5,1); zeros(length(x),1)];
fracchg=[Inf*ones(5,1); Inf*ones(length(x),1)];
options=[fracprec fracchg];
stol = 1e-15;
niter=100;
[f,p3,kvg,iter,corp,covp,covr,stdresid,Z,r2,ss]=...
  leasqr(xy, xy, p0, 'ellipse2', stol , niter, w, dp,...
	    'dellipse2',options);
% degrees of freedom
nu = length(f) - length(p3(dp==1));
%nu = length(f) - 3;
% reduced chi2 statistic
chi2 = ss/(nu-1);
% standard deviation for estimated parameters 
psd = zeros(size(p3));
sd = sqrt(diag(covp));
psd(dp==1) = sd;
fprintf(1,'conv %d iter %d r2 %.2f chi2 %f\n', kvg, iter, r2, chi2);
fprintf(1,'params est.: z(%.1f,%.1f) a=%.1f b=%.1f alpha=%.1f\n', p3(1:5));
fprintf(1,'stdev  est.: z(%.1f,%.1f) a=%.1f b=%.1f alpha=%.1f\n', psd(1:5));

[x3,y3] = ellipse(p3(1:5));

fprintf(1,'z=(%.4f,%.4f) a=%.4f b=%.4f alpha=%.4f\n', p3(1:5));

plot(x,y,'ko','MarkerSize',5)
hold on
plot(p1(1),p1(2),'b+',x1,y1,'b-',...
		 p2(1),p2(2),'g+',x2,y2,'g-',...
		 p3(1),p3(2),'r+',x3,y3,'r-')
axis equal
hold off

function [x,y] = ellipse(p)

t = linspace(0,2*pi,50)';

xc = p(1); % x-coordinate of ellipse center 
yc = p(2); % y-coordinate of ellipse center
a  = p(3); % semi-major axis
b  = p(4); % semi-minor axis
t0 = p(5); % tilt angle of semi-major axis to x-axis [rad]

Q = [cos(t0), -sin(t0); ...
     sin(t0), cos(t0)];

xp = a*cos(t);
yp = b*sin(t);

x = zeros(size(t));
y = zeros(size(t));

for i=1:length(t),
  XY = [xc;yc]+Q*[xp(i);yp(i)];
  x(i) = XY(1);
  y(i) = XY(2);
end

