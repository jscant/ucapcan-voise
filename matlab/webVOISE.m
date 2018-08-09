function webVOISE(VOISEconf)
% function webVOISE(VOISEconf)
%
% VOISEconf is a name of a configuration file containing 
% a list of parameters for VOISE. For example
% iNumSeeds = 12
% RNGiseed = 10
% dividePctile = 80
% d2Seeds = 2
% mergePctile = 50
% dmu = 0.2
% thresHoldLength = 0.3
% regMaxIter = 2
% iFile = ../share/input/sampleint.fits
% oDir = ../share/output/sampleint/

% $Id: webVOISE.m.in,v 1.9 2015/02/11 16:25:29 patrick Exp $
%
% Copyright (c) 2010-2012 Patrick Guio <patrick.guio@gmail.com>
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


% Some set up variables
global voise

voise.root    = '..';
voise.version = '1.3.2';

% disable warning about using handle graphics with -nojvm
warning('off','MATLAB:HandleGraphics:noJVM');

% load VOISE parameters from configuration file
params = readVOISEconf(VOISEconf);

% load input image and pre-process misc. filtering if required
params = loadImage(params);

% create directory if necessary
if ~exist(params.oDir,'dir')
    unix(['mkdir -p ' params.oDir]);
end

[params,IVD,DVD,MVD,CVD] = VOISE(params);
% some diagnostics generated in 
%close all
%clf
if params.printVD
    seedDist(MVD, params);
    clf
    plotHistHC(DVD, MVD, params);
end
% clf
% params = plotVDLengthScale(CVD, params);

fid = fopen([params.oDir 'CVDseeds.txt'],'w');
printSeeds(fid, CVD, params);
fclose(fid);

fid = fopen([params.oDir 'CVDneighbours.txt'],'w');
printVD(fid, CVD);
fclose(fid);

fitswrite(CVD.Vk.lambda,[params.oDir 'CVDseeds.fits']);
[Wop, Sop] = getVDOp(CVD, params.W, 1);

close all;

return
