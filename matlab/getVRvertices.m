function [V,I] = getVRvertices(VD, s)
% function [V,I] = getVRvertices(VD, s)

%
% $Id: getVRvertices.m,v 1.4 2015/02/11 16:21:37 patrick Exp $
%
% Copyright (c) 2008-2011 Patrick Guio <patrick.guio@gmail.com>
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

% seed to consider
xs = VD.Sx(s);
ys = VD.Sy(s);

% neighbour seeds
ns = VD.Nk{s};
xn = VD.Sx(ns);
yn = VD.Sy(ns);

% angle between seed s and all neighbours seeds
% -pi <= atan2(y,x)           <= pi   from x-axis
%   0 <= mod(atan2(y,x),2*pi) <= 2*pi from x-axis
asn = mod(atan2(yn-ys,xn-xs),2*pi);
% sort neighbour list (ordered anti-clockwise) 
% I is such that asnSorted = asn(I) 
[asnSorted, I] = sort(asn(:));
% close the neighbour list 
is = [I(end); I];
% get vertices as equidistant point between seed and two adjacent neighbours
% oriented anti-clockwise

rsu = [ns(is(1:end-1)), s*ones(size(asn(:))),  ns(is(2:end))];
V = getEquidistantPoint(VD, rsu);

% angle between seed s and all vertices of VR
%asv = mod(atan2(V(:,2)-ys,V(:,1)-xs),2*pi);

if 0
subplot(211)
plot(xs, ys,'xk','MarkerSize',5)
hold on
plot(xn, yn,'ok','MarkerSize',5)
plot(V([1:end 1],1), V([1:end 1],2), '-dk', 'MarkerSize',5)
hold off
W = VD.W;
set(gca, 'xlim', [W.xm W.xM], 'ylim', [W.ym W.yM]);
%pause
end

% cross product between two vectors formed by seed and two adjacent neighbours
% oriented anti-clockwise
x1 = xn(is(1:end-1)); y1 = yn(is(1:end-1));
x2 = xn(is(2:end));   y2 = yn(is(2:end));
crs = sign((x1-xs).*(y2-ys)-(y1-ys).*(x2-xs));

% if cross-product < 0 (assuming vectors oriented anti-clockwise) 
% then angle > pi and the corresponding vertex is "fake" and corresponds
% to the intersection of two unbounded edges.
% if cross-product > 0 then this is a vertex of the convex VR
V(find(crs == -1),1:2) = Inf;

if 0
subplot(212)
plot(xs, ys,'xk','MarkerSize',5)
hold on
plot(xn, yn,'ok','MarkerSize',5)
if isempty(find(crs==-1)),
plot(V([1:end 1],1), V([1:end 1],2), '-dk', 'MarkerSize',5)
else
plot(V(:,1), V(:,2), '-dk', 'MarkerSize',5)
end
hold off
W = VD.W;
set(gca, 'xlim', [W.xm W.xM], 'ylim', [W.ym W.yM]);
if ~isempty(find(crs==-1)), 
  crs'
  pause
end
end
