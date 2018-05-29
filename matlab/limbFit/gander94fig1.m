function gander94fig1
% function gander94fig1

%
% $Id: gander94fig1.m,v 1.6 2012/04/16 15:45:15 patrick Exp $
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

x = [1, 2 , 5, 7, 9, 3]';
y = [7, 6 , 8, 7, 5, 7]';


[xc,yc,R,a] = circfit(x,y);
fprintf(1,'z=(%.4f,%.4f) r=%.4f\n', xc,yc,R);
[x1,y1] = circle(xc,yc,R);

Par = CircleFitByTaubin([x,y]);
[x2,y2] = circle(Par(1),Par(2),Par(3));
fprintf(1,'z=(%.4f,%.4f) r=%.4f\n', Par(1:3));


xy = [x;y];
p0 = [xc,yc,R,atan2(y-yc,x-xc)']; 
%p0 = [Par(1:3),atan2(y-Par(2),x-Par(1))']; 
dp=[ones(1,3), ones(1,length(x))];
dp = ones(size(dp));
w = ones(size(xy));
fracprec=[zeros(3,1); zeros(length(x),1)];
fracchg=[Inf*ones(3,1); Inf*ones(length(x),1)];
options=[fracprec fracchg];
stol = 1e-15;
niter=100;
[f,p,kvg,iter,corp,covp,covr,stdresid,Z,r2,ss]=...
  leasqr(xy, xy, p0, 'circle2', stol , niter, w, dp,...
	    'dcircle2',options);
% degrees of freedom
nu = length(f) - length(p(dp==1));
%nu = length(f) - 3;
% reduced chi2 statistic
chi2 = ss/(nu-1);
% standard deviation for estimated parameters 
psd = zeros(size(p));
sd = sqrt(diag(covp));
psd(dp==1) = sd;
fprintf(1,'conv %d iter %d r2 %.2f chi2 %f\n', kvg, iter, r2, chi2);
fprintf(1,'params est.: Xc(%.1f,%.1f) R=%.1f\n', p(1:3));
fprintf(1,'stdev  est.: Xc(%.1f,%.1f) R=%.1f\n', psd(1:3));

[x3,y3] = circle(p(1),p(2),p(3));

fprintf(1,'z=(%.4f,%.4f) r=%.4f\n', p(1:3));

plot(x,y,'ko','MarkerSize',5)
hold on
plot(xc,yc,'b+',x1,y1,'b-',...
		 Par(1),Par(2),'g+',x2,y2,'g-',...
		 p(1),p(2),'r+',x3,y3,'r-')
axis equal
hold off

function [x,y] = circle(xc,yc,R)

t = linspace(0,2*pi,50)';

x = xc + R*cos(t); 
y = yc + R*sin(t);

