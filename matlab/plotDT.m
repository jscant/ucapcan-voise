function [hs,hl]=plotDT(x,y,scatterSpecs,lineSpecs)
% function [hs,hl]=plotDT(x,y)

%
% $Id: plotDT.m,v 1.4 2012/04/16 16:54:27 patrick Exp $
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

if 1

tri = delaunay(x, y);

if ~exist('scatterSpecs','var') | isempty(scatterSpecs),
  hs = scatter(x, y);
else
  hs = scatter(x, y, scatterSpecs{:});
end

hl = zeros(size(tri,1));
if ~exist('lineSpecs','var') | isempty(lineSpecs),
  for i=1:size(tri,1)
    index = [tri(i,:) tri(i,1)];
	  hl(i) = line(x(index), y(index)); 
  end
else
  for i=1:size(tri,1)
    index = [tri(i,:) tri(i,1)];
	  hl(i) = line(x(index), y(index),lineSpecs{:});
  end
end

else

tri = DelaunayTri(x, y);

specs = {};
if exist('scatterSpecs','var') & ~isempty(scatterSpecs), 
  specs = {specs{:}, scatterSpecs{:}}; 
end
if exist('lineSpecs','var') & ~isempty(lineSpecs), 
  specs = {specs{:}, lineSpecs{:}}; 
end
h=triplot(tri, x, y, specs{:});

hs = findobj(h, 'type', 'hggroup');
hl = findobj(h, 'type', 'line');

end
