function [varargout] = limbFitEx1(action,varargin)
% function varargout = limbFitEx1(action,[optional args])
%
% where action is any of 'clean', 'VOISE' and 'limbFit'
%
% limbFitEx1('clean');
% [params,IVD,DVD,MVD,CVD] = limbFitEx1('VOISE')
% [params,fit1,fit2] = limbFitEx1('limbFit')

%
% $Id: limbFitEx1.m,v 1.5 2012/04/16 15:45:15 patrick Exp $
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

switch lower(action),

   case 'clean',

	   unix(['rm -rf ' voise.root '/share/alljup_UT1013']);

   case 'voise',

     % load default parameters
     params = getDefaultVOISEParams;

     % VOISE parameters
		 params.iNumSeeds       = 30;
     params.dividePctile    = 98;
     params.d2Seeds         = 10;
     params.mergePctile     = 50;
     params.dmu             = 0.2;
     params.thresHoldLength = 0.3;
     params.regMaxIter      = 2;
     % report parameters
     params.divideExport = false;
     params.mergeExport  = false;
     params.movDiag      = false;

		 % allow command line modifications
		 params = parseArgs(params, varargin{:});

     % set image filename
     params.iFile = [voise.root '/share/alljup_UT1013.fits'];
     % set output parameters
     params.oDir = [voise.root '/share/alljup_UT1013/'];
     params.oMatFile = 'voise';

     % load image from fits file
     params.Wo = fitsread(params.iFile);

     % set up filter parameters
     params.winSize = [11,11];
     params.filter = @median;
     params.W  = filterImage(params.Wo,params.winSize,params.filter);
     %[params.W,xbins,cdf] = histEq(params.W,256);

     % set axes limits
     params.x0   = (1+size(params.W,2))/2;
     params.x    = [1:size(params.W,2)]-params.x0;
     params.y0   = (1+size(params.W,1))/2;
     params.y    = [1:size(params.W,1)]-params.y0;

     params.Wlim = [min(params.W(:)) max(params.W(:))];
     params.xlim = [min(params.x) max(params.x)];
     params.ylim = [min(params.y) max(params.y)];

     if ~exist(params.oDir,'dir')
       unix(['mkdir -p ' params.oDir]);
     end

     close all

     [params,IVD,DVD,MVD,CVD] = VOISE(params, varargin{:});

		 varargout{1} = params;
		 varargout{2} = IVD;
		 varargout{3} = DVD;
		 varargout{4} = MVD;
		 varargout{5} = CVD;

   case 'limbfit',

	   path = [voise.root '/share/alljup_UT1013/'];
		 data = 'voise';
		 fprintf(1,'Opening %s%s\n',path,data);
		 eval(['load ' path data]);

		 VD = DVD;
		 vdtype = 'DVD';

     % initial guess
		 if 1
		   p0 = [0 0 300 280 0];
     else
		   p0 = getEllipseParams();
     end
		 pp = 1:length(p0);
		 fit1 = getDefaultFitParams(p0);
		 fit1.LSmax = 16;
		 fit1.Rmin = 0.9;
		 fit1.Rmax = 1.1;
		 fit1.VD = vdtype;
		 fit1.dp = [1 1 1 1 0];

     % allow command line modifications
     fit1 = parseArgs(fit1, varargin{:});

		 fit1 = getLimb2(CVD, params, fit1);

		 % try again with better selected seeds
		 fit2 = getDefaultFitParams(fit1.p(pp));
		 fit2.LSmax = 12;
		 fit2.Rmin = 0.95;
		 fit2.Rmax = 1.05;
		 fit2.VD = vdtype;
		 fit2.dp = [1 1 1 1 0];

		 % allow command line modifications
		 fit2 = parseArgs(fit2, varargin{:});

		 close all

		 fit2 = getLimb2(CVD, params, fit2);

		 orient landscape, set(gcf,'PaperOrientation','portrait');
		 printFigure(gcf,[path '/select.eps']);

     subplot(111)
		 plotLimbFit(params,fit1,fit2);

		 orient landscape, set(gcf,'PaperOrientation','portrait');
		 printFigure(gcf,[path '/fit.eps']);

		 varargout{1} = params;
		 varargout{2} = fit1;
		 varargout{3} = fit2;

end
