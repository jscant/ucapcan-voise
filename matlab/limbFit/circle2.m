function r=circle2(xy,p)
% function r=circle2(xy,p)

%
% $Id: circle2.m,v 1.5 2012/04/16 15:45:15 patrick Exp $
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

global verbose

if ~isempty(verbose) & length(verbose)>2 & verbose(3)
  fprintf(1,'calling circle (xc,yc,r)=(%.1f,%.1f,%.1f)\n', p(1:3));
end

xc = p(1); % x-coordinate of circle center 
yc = p(2); % y-coordinate of circle center
r0 = p(3); % radius
ti = p(4:end); % angles

ni = length(xy);
ni2 = fix(ni/2);

xi = xy(1:ni2);
yi = xy(ni2+1:ni);

x = xc + r0*cos(ti);
y = yc + r0*sin(ti);

r = [x;y];

if 0
plot(xi,yi,'ro',x,y,'bo')
drawnow
end

