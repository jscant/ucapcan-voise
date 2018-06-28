function X = getEquidistantPoint(VD, rsu)
% function X = getEquidistantPoint(VD, rsu)
%
% Find X equally distant from S(r), S(s) and S(u)
% where seeds (r, s u) are in the matrix rsu with size (nx, 3)

%
% $Id: getEquidistantPoint.m,v 1.3 2012/04/16 16:54:27 patrick Exp $
%
% Copyright (c) 2008-2012 Patrick Guio <patrick.guio@gmail.com>
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


r = rsu(:,1);
x1 = VD.Sx(r); y1 = VD.Sy(r);

s = rsu(:,2);
x2 = VD.Sx(s); y2 = VD.Sy(s);

u = rsu(:,3);
x3 = VD.Sx(u); y3 = VD.Sy(u);

% (x,y) / a1*x + b1*y = c1 
% are points of bisector of X3,X1
% \vec{X_3X_1}.\vec{OX} = |\vec{OX_1}|^2-|\vec{OX_3}|^2/2
 
% \vec{X_3X_1}
a1 = x1-x3;
b1 = y1-y3;
% |\vec{OX_1}|^2-|\vec{OX_3}|^2/2
c1 = (x1.^2+y1.^2-x3.^2-y3.^2)/2;

% (x,y) / a2*x + b2*y = c1
% are points of bisector of X3,X2
% \vec{X_3X_2}.\vec{OX} = |\vec{OX_1}|^2-|\vec{OX_2}|^2/2

% \vec{X_3X_2}
a2 = x2-x3;
b2 = y2-y3;
% |\vec{OX_2}|^2-|\vec{OX_3}|^2/2
c2 = (x2.^2+y2.^2-x3.^2-y3.^2)/2;

x = (b1.*c2-c1.*b2)./(b1.*a2-b2.*a1);
y = (c1.*a2-a1.*c2)./(b1.*a2-b2.*a1);

% \vec{X_3X_1}\times\vec{X_3X_2}
p2p1xp3p2 = b1.*a2-b2.*a1;
% find out whether X1, X2 and X3 collinear
ii = find(p2p1xp3p2==0);
x(ii) = Inf;
y(ii) = Inf;

if 0,
  fprintf(1,'distance = %g %g %g\n', ...
    (x1-x).^2+(y1-y).^2,(x2-x).^2+(y2-y).^2,(x3-x).^2+(y3-y).^2);
end

% list of Xs with size(nX, 2)
X = [x(:), y(:)];

