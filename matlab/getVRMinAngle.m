function minAngle = getVRMinAngle(VD, sk)
% function minAngle = getVRMinAngle(VD, sk)

%
% $Id: getVRMinAngle.m,v 1.3 2012/04/16 16:54:27 patrick Exp $
%
% Copyright (c) 2009-2012 Patrick Guio <patrick.guio@gmail.com>
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

% get vertices list of VR(sk) 

[V,I] = getVRvertices(VD, sk);

% close list of vertice points 
x = [V(:,1); V(1,1)];
y = [V(:,2); V(1,2)];

% list of vertice vectors
vx = diff(x);
vy = diff(y);

% normalise vectors
normv = sqrt(vx.^2+vy.^2);
vx = vx./normv;
vy = vy./normv;

vx = [vx(end); vx];
vy = [vy(end); vy];

right =  [vx([2:end]), vy([2:end])]';
left  = -[vx([1:end-1])  , vy([1:end-1])]';

% calculate the cosine of interior angles for all vertices
cosAB = dot(left,right);

% derive the angle in radian within 0 and \pi
Angles = acos(cosAB(:));

% minimum angle
minAngle = min(Angles);

if 0, % diagnostic plot

if all(isfinite(Angles))
  numSumAngles = sum(Angles);
  % the sum of the interior angles of any polygon is \pi*(n_v-2)
  % where n_v is the number of vertices
  nv = size(V,1);
  theSumAngles = pi*(nv-2)
  fprintf(1,'sum Angles %f (%f) abs(error) %g\n', ...
          180/pi*[numSumAngles, theSumAngles, abs(numSumAngles-theSumAngles)]);
end

subplot(211),
plot(x,y,'-x');
for i=1:length(x)-1,
  if isfinite(x(i)) & isfinite(y(i)),
	  text(x(i), y(i), num2str(i), 'verticalalignment', 'bottom');
	end
end
axis equal
subplot(212)
for i=1:size(left,2),

  if isfinite(right(:,i)) & isfinite(left(:,i)),
	  plot([0 left(1,i)],[0 left(2,i)], [0 right(1,i)], [0 right(2,i)])
	  axis equal
	  fprintf(1, 'vertice %d cos(Angle) %+.2f Angle %6.1f\n', ...
	          i, cosAB(i), 180/pi*Angles(i));
	  pause
	end

end

end
