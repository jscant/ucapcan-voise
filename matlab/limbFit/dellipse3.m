function dr=dellipse3(xy,f,p,dp,func)
% function dr=dellipse3(xy,f,p,dp,func)

%
% $Id: dellipse3.m,v 1.4 2015/12/04 15:56:04 patrick Exp $
%
% Copyright (c) 2012-2015 Patrick Guio <patrick.guio@gmail.com>
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
  fprintf(1,'calling dellipse3 (xc,yc,a,e,t0)=(%.1f,%.1f,%.1f,%.1f,%.0f)\n',...
          p(1:5));
end


xc = p(1); % x-coordinate of ellipse center 
yc = p(2); % y-coordinate of ellipse center
a  = p(3); % semi-major axis
e  = p(4); % eccentricity
t0 = p(5); % tilt angle of semi-major axis to x-axis [rad]
ti = p(6:end); % angles

ni = length(xy);
m = fix(ni/2);

xi = xy(1:m);
yi = xy(m+1:ni);

% semi-minor axis
b  = a * sqrt(1-e^2);

ci = cos(ti);
si = sin(ti);

Q = rot(t0);
Qp = rotprime(t0);

dgdxc = zeros(ni,1);
dgdyc = zeros(ni,1);
dgda  = zeros(ni,1);
dgde  = zeros(ni,1);
dgdt0 = zeros(ni,1);
dgdti = zeros(ni,1);
for i=1:m,
  % d/dxc
  dgdxc(i+[0,m]) = [1;0];
  % d/dyc
  dgdyc(i+[0,m]) = [0;1];
  % d/da
  dgda(i+[0,m]) = Q*[ci(i);sqrt(1-e^2)*si(i)];
  % d/de
  dgde(i+[0,m]) = Q*[0;-a*e/sqrt(1-e^2)*si(i)];
  % d/dt0
  dgdt0(i+[0,m]) = Qp*[a*ci(i);b*si(i)];
  % d/dti
  dgdti(i+[0,m]) = Q*[-a*si(i);b*ci(i)];
end

% drs is [drs/dxc, drs/dyc, drs/da, drs/de, drs/dt0, drs/dti....]
dr = [dgdxc, dgdyc, dgda, dgde, dgdt0,[diag(dgdti(1:m));diag(dgdti(m+1:ni))]];


function Q = rot(alpha)

Q = [cos(alpha), -sin(alpha); ...
     sin(alpha), cos(alpha)];

% derivative of rotation matrix
function Qp = rotprime(alpha)

Qp = [-sin(alpha), -cos(alpha); ...
      cos(alpha), -sin(alpha)];
