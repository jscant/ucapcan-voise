function dr=dellipse4(xy,f,p,dp,func)
% function dr=dellipse4(xy,f,p,dp,func)

%
% $Id: dellipse4.m,v 1.2 2015/12/04 15:56:04 patrick Exp $
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
  fprintf(1,'calling dellipse4 (xc,yc,a1,e1,t1,a2,e2,t2)=(%.1f,%.1f,%.1f,%.1f,%.0f,%.1f,%.1f,%.0f)\n',...
          p(1:8));
end


xc = p(1); % x-coordinate of ellipse center 
yc = p(2); % y-coordinate of ellipse center
a1 = p(3); % semi-major axis
e1 = p(4); % eccentricity
t1 = p(5); % tilt angle of semi-major axis to x-axis [rad]
a2 = p(6); % semi-major axis
e2 = p(7); % eccentricity
t2 = p(8); % tilt angle of semi-major axis to x-axis [rad]
ti = p(9:end); % angles

ni = length(xy);
% number of points
m = fix(ni/2);

% points to fit
xi = xy(1:m);
yi = xy(m+1:ni);


% semi-minor axis
b1  = a1 * sqrt(1-e1^2);
b2  = a2 * sqrt(1-e2^2);

ci = cos(ti);
si = sin(ti);

Q1 = rot(t1);
Qp1 = rotprime(t1);

Q2 = rot(t2);
Qp2 = rotprime(t2);

dgdxc = zeros(ni,1);
dgdyc = zeros(ni,1);
dgda1 = zeros(ni,1);
dgde1 = zeros(ni,1);
dgdt1 = zeros(ni,1);
dgda2 = zeros(ni,1);
dgde2 = zeros(ni,1);
dgdt2 = zeros(ni,1);
dgdti = zeros(ni,1);
for i=1:m,
	% d/dxc
	dgdxc(i+[0,m]) = [1;0];
	% d/dyc
	dgdyc(i+[0,m]) = [0;1];
	if iModels(i)==1,
	  % d/da1
	  dgda1(i+[0,m]) = Q1*[ci(i);sqrt(1-e1^2)*si(i)];
	  % d/de1
	  dgde1(i+[0,m]) = Q1*[0;-a1*e1/sqrt(1-e1^2)*si(i)];
	  % d/dt1
	  dgdt1(i+[0,m]) = Qp1*[a1*ci(i);b1*si(i)];
    % d/dti
    dgdti(i+[0,m]) = Q1*[-a1*si(i);b1*ci(i)];
	elseif iModels(i)==2,
	  % d/da2
	  dgda2(i+[0,m]) = Q2*[ci(i);sqrt(1-e2^2)*si(i)];
	  % d/de2
	  dgde2(i+[0,m]) = Q2*[0;-a2*e2/sqrt(1-e2^2)*si(i)];
	  % d/dt2
	  dgdt2(i+[0,m]) = Qp2*[a2*ci(i);b2*si(i)];
    % d/dti
    dgdti(i+[0,m]) = Q2*[-a2*si(i);b2*ci(i)];
	end
end

% drs is [drs/dxc, drs/dyc, ...
%         drs/da1, drs/de1, drs/dt1, ...
%         drs/da2, drs/de2, drs/dt2, drs/dti, ...]
dr = [dgdxc, dgdyc, ...
      dgda1, dgde1, dgdt1,...
      dgda2, dgde2, dgdt2, [diag(dgdti(1:m));diag(dgdti(m+1:ni))]];


function Q = rot(alpha)

Q = [cos(alpha), -sin(alpha); ...
     sin(alpha), cos(alpha)];

% derivative
function Qp = rotprime(alpha)

Qp = [-sin(alpha), -cos(alpha); ...
      cos(alpha), -sin(alpha)];


