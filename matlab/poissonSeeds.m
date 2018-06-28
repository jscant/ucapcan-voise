function S = poissonSeeds(nr,nc,ns,VDlim)
% function S = poissonSeeds(nr,nc,ns,VDlim)
% 
% Poisson disk sampling algorithm described in
% http://devmag.org.za/2009/05/03/poisson-disk-sampling/

%
% $Id: poissonSeeds.m,v 1.8 2015/04/14 11:59:00 patrick Exp $
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

xm = VDlim.xm;
xM = VDlim.xM;
ym = VDlim.ym;
yM = VDlim.yM;

% Poisson disk algorithm described in
% http://devmag.org.za/2009/05/03/poisson-disk-sampling/
% and implementation based on the Matlab code found at
% http://cusacklabcomputing.blogspot.ca/2013/07/poisson-disc-2d-in-matlab.html

width  = xM-xm;
height = yM-ym; 
% min separation of points
% rectangular
minDist = sqrt(width*height/ns);
% circle
%minDist = 2/sqrt(pi)*sqrt(width*height/ns);


% higher number gives higher quality (fewer gaps)
newPointsCount = 10*ns;

% Create the grid
cellSize = minDist/sqrt(2);

nx = ceil(width/cellSize); % grid width
ny = ceil(height/cellSize); % grid height
grid = cell(nx, ny);

% procList pops a random element from the queue
procList = [];
samplePoints = [];

% Generate the first point randomly and updates
firstPoint = ceil([xm+(xM-xm)*rand(1,1), ym+(yM-ym)*rand(1,1)]);

% Update containers
procList = [procList; firstPoint];
samplePoints = [samplePoints; firstPoint];
gridPoint = imageToGrid(firstPoint,cellSize,VDlim);
grid{gridPoint(1),gridPoint(2)} = firstPoint;

while ~isempty(procList)
  randrow = ceil(rand(1,1)*size(procList,1));
	point = procList(randrow,:);
	procList(randrow,:) = [];

	for i=1:newPointsCount,
	  newPoint = generateRandomPointsAround(point, minDist);
    % Check that the point is in the image region
    % and no point exists in the point's neighbourhood
		if inRectangle(newPoint, VDlim) && ... 
       ~inNeighbourhood(grid, newPoint, minDist, cellSize, VDlim),
			 procList = [procList; newPoint];
			 samplePoints = [samplePoints; newPoint];
			 gridPoint = imageToGrid(newPoint,cellSize,VDlim);
			 grid{gridPoint(1),gridPoint(2)} = newPoint;
		end
	end

end

S = round(samplePoints);

fprintf(1,'poissonSeeds: ns=%d, minDist=%.2f, card(S)=%d\n', ...
        ns, minDist, size(S,1));

function gridPoint = imageToGrid(point,cellSize,VDlim)

gridPoint = ceil((point-[VDlim.xm,VDlim.ym])/cellSize);
%[point,gridPoint]
%pause

function newPoint = generateRandomPointsAround(point,minDist)
% non-uniform, favours point closer to the inner ring, 
% leads to denser packings

% random angle
t = 2*pi*rand(1,1);
% random radius between minDist and 2*minDist
r = minDist*(rand(1,1)+1);
newPoint = point + r*[cos(t),sin(t)];
%pause

function isIn = inNeighbourhood(grid, point, minDist, cellSize, VDlim)

gridSize = size(grid);

% Where does this point belong in the grid
gridPoint = imageToGrid(point,cellSize,VDlim);

% only check neighbours -2<delta<2 in each dim arount "gridPoint"
[ox,oy] = meshgrid([-2:2],[-2:2]); % 5 x 5 = 25
c = repmat(gridPoint,[size(ox(:),1),1])+[ox(:),oy(:)];

% Reject any putative neighbours that are out of bounds
c(any(c<1,2) | c(:,1)>gridSize(1) | c(:,2)>gridSize(2),:) = [];

% Reject any putative neighbours without points
c(isempty(cat(1,grid{sub2ind(gridSize,c(:,1),c(:,2))})),:) = [];

% Get points from grid neighbours 
neighbourPoints = cat(1,grid{sub2ind(gridSize,c(:,1),c(:,2))});

if ~isempty(neighbourPoints), 
  % check that previously generated points are too close, 
	% i.e. less than minDist
  dists = sqrt(sum((neighbourPoints- ...
                   repmat(point,[size(neighbourPoints,1), 1])).^2,2));
  isIn = any(dists<minDist);
else
  isIn = false;
end
%[point isIn]
%pause

function isIn = inRectangle(p,W)

isIn = p(1)>=W.xm && p(1)<=W.xM && p(2)>=W.ym && p(2)<=W.yM;
%[p isIn]
%pause
  
