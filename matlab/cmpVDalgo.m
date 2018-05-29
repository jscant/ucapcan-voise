function [VD,VDf] = cmpVDalgo(nr,nc,ns,initSeeds,varargin)
% function [VD,VDf] = cmpVDalgo(nr,nc,ns,initSeeds,varargin)
%
% example: 
% [VD,VDf] = cmpVDalg(100,100,12,@randomSeeds);

%
% $Id: cmpVDalgo.m,v 1.5 2012/04/16 16:54:27 patrick Exp $
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


[VD,VDf] = testSeq(Z, ns, initSeeds, varargin{:});


function [VD,VDf] = testSeq(W, ns, initSeeds, varargin)
% function [VD,VDf] = testSeq(W, ns, initSeeds, varargin)
% 
% add and remove ns seeds

[nr, nc] = size(W);

if exist('initSeeds') & isa(initSeeds, 'function_handle'),
  [initSeeds, msg] = fcnchk(initSeeds);
  S = initSeeds(nr, nc, ns, varargin{:});
else
  error('initSeeds not defined or not a Function Handle');
end

t=tic;
VD = computeVD(nr, nc, S);
toc(t)

t=tic;
VDf = computeVDFast(nr, nc, S);
toc(t)

subplot(221), imagesc(VD.Vk.lambda)
subplot(222), imagesc(VDf.Vk.lambda)
subplot(223), imagesc(VD.Vk.v)
subplot(224), imagesc(VDf.Vk.v)

find(VD.Vk.lambda~=VDf.Vk.lambda)
find(VD.Vk.v~=VDf.Vk.v)
return


[WVD, SVD] = getVDOp(VD, W, @mean);
subplot(211), imagesc(WVD)
[WVDf, SVDf] = getVDOp(VDf, W, @mean);
subplot(212), imagesc(WVDf)

return

plotVDOp(VD, W, @(x) median(x))
pause

if 0
ks = ns:-1:4;
seedList = ks([[2:2:end],[1:2:end]]);
else
seedList = 4:ns;
end

for k = seedList,
	VD  = removeSeedFromVD(VD, k);
	drawVD(VD);
end

plotVDOp(VD, W, @(x) median(x))


