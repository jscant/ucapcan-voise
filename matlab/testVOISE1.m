function [params,IVD,DVD,MVD,CVD] = testVOISE1(varargin)
% function [params,IVD,DVD,MVD,CVD] = testVOISE1([optional args])
%
% Examples:
%
% [params,IVD,DVD,MVD,CVD] = testVOISE1();
% [params,IVD,DVD,MVD,CVD] = testVOISE1('iNumSeeds',20,'dividePctile',92);
% [params,IVD,DVD,MVD,CVD] = testVOISE1('xlim',[-50 300],'ylim',[-50 300]);
% 
% Optional arguments are pairs of arguments, the first one is a string
% representing a valid field of the VOISE parameter structure generated 
% by the function getDefaultVOISEParams.
%
% To get a list of these fields type the Matlab command
% >> help getDefaultVOISEParams
% 
% Note that this test can take a *VERY* long time (1-2 hours)

%
% $Id: testVOISE1.m,v 1.13 2012/04/16 16:54:28 patrick Exp $
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

start_VOISE

% miscellaneous information about VOISE
global voise

% load default VOISE parameters
params = getDefaultVOISEParams;

% modify some VOISE algorithm parameters

% initialising
params.iNumSeeds       = 12;
% Dividing
params.dividePctile    = 95;
params.d2Seeds         = 4;
% Merging
params.mergePctile     = 60;
params.dmu             = 0.2;
params.thresHoldLength = 0.3;
% Regularise
params.regMaxIter      = 1;
% I/O parameters
params.iFile           = [voise.root '/share/testPic.mat'];
params.oDir            = [voise.root '/share/testPic/'];
params.oMatFile        = 'voise';
% diagnostics parameters
params.divideExport    = false;
params.mergeExport     = false;
params.movDiag         = false;
params.movPos          = [600 50 1300 1050]; % movie window size

% allow for command line parameter modifications
params = parseArgs(params, varargin{:});

% load image file
params = loadImage(params);

% take the negative image
params.W = max(params.W(:))-params.W;

% Reset colour limits
params.Wlim = [min(params.W(:)) max(params.W(:))];

% create directory if necessary
if isunix & ~exist(params.oDir,'dir')
  unix(['mkdir -p ' params.oDir]);
end

% run VOISE
[params,IVD,DVD,MVD,CVD] = VOISE(params, varargin{:});

