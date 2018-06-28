function S = weightedPoissonSeeds(nr,nc,ns,VDlim)
% function S = weightedPoissonSeeds(nr,nc,ns,VDlim)
% 
% Poisson disk sampling algorithm described in
% http://devmag.org.za/2009/05/03/poisson-disk-sampling/

%
% $Id: weightedPoissonSeeds.m,v 1.1 2015/04/16 13:14:37 patrick Exp $
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

% distribution function: array of size nr x nc
global poissonWeight

if all(size(poissonWeight)==[nr,nc]),
  mnW = min(poissonWeight(:));
	mxW = max(poissonWeight(:));
  fprintf(1,'poissonWeight range %.2f %.2f\n', mnW, mxW);
else
  me = MException('MyFunction:weightedPoissonSeeds',...
                  ['Problem with poissonWeight' ...
                   '\nCheck that poissonWeight is declared global' ...
                   '\nAnd/or check its size (should be %dx%d)'],nr,nc);
	throw me;
end
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

minDist = minDist/(mnW+mxW)*2;

% higher number gives higher quality (fewer gaps)
newPointsCount = 10*ns;

% Create the grid
cellSize = minDist/sqrt(2);

nx = ceil(width/cellSize); % grid width
ny = ceil(height/cellSize); % grid height
gridList = cell(nx, ny);
for i=1:nx,
  for j=1:ny,
	  gridList{i,j} = {};
	end
end

% procList pops a random element from the queue
procList = [];
samplePoints = [];

% Generate the first point randomly and updates
firstPoint = ceil([xm+(xM-xm)*rand(1,1), ym+(yM-ym)*rand(1,1)]);

% Update containers
procList = [procList; firstPoint];
samplePoints = [samplePoints; firstPoint];
gridPoint = imageToGrid(firstPoint,cellSize,VDlim);
gridList{gridPoint(1),gridPoint(2)} = { firstPoint };

while ~isempty(procList) && length(procList)<1000,
  randrow = ceil(rand(1,1)*size(procList,1));
	point = procList(randrow,:);
	procList(randrow,:) = [];

	for i=1:newPointsCount,
	  fraction = interp2(poissonWeight,point(1),point(2));
	  newPoint = generateRandomPointsAround(point, fraction*minDist);
    % Check that the point is in the image region
    % and no point exists in the point's neighbourhood
		if inRectangle(newPoint, VDlim) && ... 
       ~inNeighbourhood(gridList, newPoint, fraction*minDist, cellSize, VDlim),
			 procList = [procList; newPoint];
			 samplePoints = [samplePoints; newPoint];
			 gridPoint = imageToGrid(newPoint,cellSize,VDlim);
			 gridList{gridPoint(1),gridPoint(2)} = { ...
			 gridList{gridPoint(1),gridPoint(2)}{:}, newPoint};

%			 fprintf(1,'ok %d ',length(procList))
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

function isIn = inNeighbourhood(gridList, point, minDist, cellSize, VDlim)

gridSize = size(gridList);

% Where does this point belong in the grid
gridPoint = imageToGrid(point,cellSize,VDlim);

isIn = false;

for i=max([1,gridPoint(1)-2]):min([gridSize(1),gridPoint(1)+2]),
  for j=max([1,gridPoint(2)-2]):min([gridSize(2),gridPoint(2)+2]),
	  for l=1:length(gridList{i,j}),
		  if sqrt(sum((point-gridList{i,j}{l}).^2,2)) < minDist,
			  isIn = true;
        return
			end
		end
  end
end


function isIn = inRectangle(p,W)

isIn = p(1)>=W.xm && p(1)<=W.xM && p(2)>=W.ym && p(2)<=W.yM;
%[p isIn]
%pause
  
