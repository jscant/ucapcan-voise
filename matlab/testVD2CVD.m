function [VD,CVD] = testVD2CVD(nr,nc,ns,initSeeds,varargin)
% function [VD,CVD] = testVD2CVD(nr,nc,ns,initSeeds,varargin)
%
% example:
%
% VD = testVD2CVD(100,100,50,@randomSeeds)

%
% $Id: testVD2CVD.m,v 1.5 2012/04/16 16:54:28 patrick Exp $
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

% number of rows in image corresponds to y coordinate
if ~exist('nr'),
  nr = 100;
end

% number of cols in image corresponds to x coordinate
if ~exist('nc'),
  nc = 100;
end

% number of seeds 
if ~exist('ns'),
  ns = 50;
end

x = linspace(-2,1,nc);
y = linspace(-1,1,nr);

[X,Y] = meshgrid(x,y);

% [X(1,1)    , Y(1,1)    ] = -1  -1
% [X(1,end)  , Y(1,end)  ] =  1  -1
% [X(end,1)  , Y(end,1)  ] = -1  -1
% [X(end,end), Y(end,end)] =  1   1

Z = exp(-(X/2).^2-(Y/2).^2);

imagesc(x,y,Z)
axis xy

% init seed of Mersenne-Twister RNG
rand('twister',10);

[VD, CVD] = VD2CVD(Z, ns, initSeeds, varargin{:});


function [VD, CVD] = VD2CVD(W, ns, initSeeds, varargin)
% function [VD, CVD] = VD2CVD(W, ns, initSeeds, varargin)

[nr, nc] = size(W);

if exist('initSeeds') & isa(initSeeds, 'function_handle'),
  [initSeeds, msg] = fcnchk(initSeeds);
  S = initSeeds(nr, nc, ns, varargin{:});
else
  error('initSeeds not defined or not a Function Handle');
end

VD = computeVD(nr, nc, S);

plotVDOp(VD, W, @(x) median(x))
pause

params.W = W;
params.regMaxIter = 50;

vdc = figure;
CVD = getCentroidVD(VD,params);
plotVDOp(CVD, W, @(x) median(x))


