function params = getDefaultVOISEParams()
% function params = getDefaultVOISEParams()
%
% Returns a default VOISE parameters structure params. 
%
% For further details on the VOISE algorithm parameters see the paper
% The VOISE Algorithm: a Versatile Tool for Automatic
% Segmentation of Astronomical Images, Guio and Achilleos,
% 398, 1254-1262, 2009 (doi 10.1111/j.1365-2966.2009.15218.x).
%
% Following is a list of all available fields (with default value in
% parentheses).
%
% * Images parameters
%
%   W              : image (matrix with size nr x nc)        (empty)
%   x              : x-axis of image (vector with length nc) (empty)
%   y              : y-axis of image (vector with length nr) (empty)
%
%   Wlim           : image intensity range for diagnostics   (empty)
%   xlim           : x-axis range for diagnostics            (empty)
%   ylim           : y-axis range for diagnostics            (empty)
%
%   imageOrigo     : image origo (in pixel unit)             ([0,0])
%   pixelSize      : pixel size along (x,y)                  ([1,1])
%   pixelUnit      : units for pixel size along (x,y)        ({'pixels','pixels'})
%   HSTFitsParam   : enable/disable HST fits parameters decoding
%                                                            (true)
%   HSTPlanetParam : enable/disable HST planet parameters calculation
%                                                            (false)
%
%   colormap       : name of the colormap for the image      (jet)
%
%
% * VOISE initial phase parameters
%
%   initSeeds      : function (string or handle) to draw initial seeds
%                                                            (@poissonSeeds)
%   pcClipping     : percentage Clipping [left,right,bottom,top]
%                                                            (empty)
%   radFluct       : Radius of fluctuation in pixels for seed shaking
%                                                            (empty)
%   iNumSeeds      : number of initial seeds                 (12)
%   RNGiseed       : initial value for Random Number Generator
%                                                            (10)
%   initAlgo       : Voronoi algorithm (0 incremental, 1 full, 2 optimal)
%                                                            (2)
%
% * VOISE dividing phase parameters
%
%   dividePctile   : percentile p_D for division             (80)
%   d2Seeds        : square distance between seeds           (4)
%   divideAlgo     : Voronoi algorithm (0 incremental, 1 full, 2 optimal)
%                                                            (2)
% 
% * VOISE merging phase parameters
%
%   mergePctile    : percentile p_M for merging              (60)
%   dmu            : maximum dissimilarity \Delta\mu         (0.2)
%   ksd            : coefficient to compare mean and std     (2)
%                    if |m|>ksd std then use relative 
%                    dissimilarity otherise check whether 
%                    the difference in intensity is ksd time
%                    the square root of the variance
%   thresHoldLength: max ratio non homogeneous/total length \mathcal{H}
%                                                            (0.3)
%   mergeAlgo      : Voronoi algorithm (0 incremental, 1 full, 2 optimal,  3 mex)
%                                                            (3)
%
% * VOISE regularisation phase parameters
%
%   regMaxIter     : maximum numbers of iterations           (1)
%   regAlgo        : Voronoi algorithm (0 incremental, 1 full, 2 optimal)
%                                                            (2)
%
% * I/O data path and filename parameters
% 
%   iFile          : input image file                        (empty)
%   oDir           : output directory                        (empty)
%   oMatFile       : VOISE data output mat-filename          ('voise.mat')
%   oLogFile       : VOISE log filename                      ('voise.log')
%   oMovFile       : VOISE movie filename                    ('voise.avi')
%
% * image pre-processing
%
%   winSize        : size of the filtering                   (empty)
%   filter         : filter name or mask matrix              (empty)
% 
%   noiseThres     : noise threshold for log transform       (empty)
%
%   histEqBin      : number of bins for histogram equalisation
%                                                            (empty)
%
% * Diagnostics/reporting parameters
%
%   logVOISE       : log flag                                (true)
%   divideExport   : export all divide iterations            (false)
%   mergeExport    : export all merge iterations             (false)
%   regExport      : export all reg iterations               (false)
%   movDiag        : create movie                            (false)
%   movPos         : movie window size                       ([600 50 1300 1050])


%
% $Id: getDefaultVOISEParams.m,v 1.19 2018/05/29 11:11:49 patrick Exp $
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

% Image parameters
params.W               = [];
params.x               = [];
params.y               = [];
%  
params.Wlim            = [];
params.xlim            = [];
params.ylim            = [];
% default for pixels
params.imageOrigo      = [0, 0];
params.pixelSize       = [1, 1];
params.pixelUnit       = {'pixels','pixels'};
% get HST fits params
params.HSTFitsParam    = true;
% get HST planet params
params.HSTPlanetParam  = false;
% colormap
params.colormap        = jet;

% VOISE algorithm parameters 
% Initialise
params.initSeeds       = @poissonSeeds;
params.pcClipping      = [];
params.radFluct        = [];
params.iNumSeeds       = 12;
params.RNGiseed        = 10;
% 3 C++ batch SKIZ
params.initAlgo        = 3;
% Dividing
params.dividePctile    = 80;
params.d2Seeds         = 4;
% divideAlgo choice
% 0 incremental 
% 1 full
% 2 timing based
% 3 C++ batch SKIZ
params.divideAlgo      = 3;
params.centroidAlgo    = 3;

% Merging
params.mergePctile     = 60;
params.dmu             = 0.2;
params.ksd             = 2;
params.thresHoldLength = 0.3;
% mergeAlgo choice
% 0 incremental 
% 1 full
% 2 timing based
params.mergeAlgo       = 3;

% Regularise
params.regMaxIter      = 1;
% regAlgo choice
% 0 incremental 
% 1 full
% 2 timing based
params.regAlgo         = 3;

% inputs/output paths
params.iFile           = [];               % input image file 
params.oDir            = [];               % output directory
params.oMatFile        = 'voise.mat';      % output mat filename
params.oLogFile        = 'voise.log';      % log filename
params.oMovFile        = 'voise.avi';      % movie filename

% filterImage
params.winSize         = [];               % size of the filtering
params.filter          = [];               % type of filter
% log filter
params.noiseThres      = [];
% histEq
params.histEqBin       = [];

% Diagnostics/Report parameters
%
% log output of VOISE run
params.logVOISE        = true;
%
% Export divide/merge/reg plot to eps
params.divideExport    = false;
params.mergeExport     = false;
params.regExport       = false;
%
% no pause at all
params.pause           = false;
%
% Movie parameters
params.movDiag         = false;
params.movPos          = [600 50 1300 1050]; % movie window size

params.printVD         = 1; % Show VD at each stage, save VD to file
params.dpi             = 300; % Print quality
params.n_clusters      = -1; % Choose clusters based on silhouette
params.clus            = 0;
