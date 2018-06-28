function VD = testIncVD(nr,nc,ns,initSeeds,clipping,radfluct)
% function VD = testIncVD(nr,nc,ns,initSeeds,clipping,radfluct)
%
% example: 
% VD = testIncVD(100,100,12,@randomSeeds);

%
% $Id: testIncVD.m,v 1.6 2015/02/14 15:02:21 patrick Exp $
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
if ~exist('nr','var') || isempty(nr),
  nr = 100;
end

% number of cols in image corresponds to x coordinate
if ~exist('nc','var') || isempty(nc),
  nc = 100;
end

% number of seeds 
if ~exist('ns','var') || isempty(ns),
  ns = 50;
end

if ~exist('initSeeds','var') || isempty(initSeeds),
  initSeeds = @randomSeeds;
end

if ~exist('clipping','var') || isempty(clipping),
  clipping = [0,0,0,0];
end

if ~exist('radfluct','var') || isempty(radfluct),
  radfluct = 0;
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

VD = testSeq(Z, ns, initSeeds, clipping, radfluct);


function VD = testSeq(W, ns, initSeeds, clipping, radfluct)
% function VD = testSeq(W, ns, initSeeds, clipping, radfluct)
% 
% add and remove ns seeds

[nr, nc] = size(W);

if exist('initSeeds') & isa(initSeeds, 'function_handle'),
  [initSeeds, msg] = fcnchk(initSeeds);
  VDlim = setVDlim(nr,nc,clipping);
  S = initSeeds(nr, nc, ns, VDlim);
  if ~isempty(radfluct),
    S = shakeSeeds(S,nr,nc,VDlim,radfluct);
  end
  ns = size(S,1);
else
  error('initSeeds not defined or not a Function Handle');
end

VD = computeVD(nr, nc, S, VDlim);

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


