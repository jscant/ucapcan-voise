function [params,IVD,DVD,MVD,CVD] = VOISEf(params, ns, initSeeds, varargin)
% function [params,IVD,DVD,MVD,CVD] = VOISEf(params, ns, initSeeds, varargin)

%
% VOronoi Image SEgmentation 
%
% $Id: VOISEf.m,v 1.5 2015/02/13 12:35:46 patrick Exp $
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

%[s,w] = unix(['rm -f ' params.oDir '*.eps']);

% save image parameters
save([params.oDir params.oMatFile], 'params'); 
% plot image
params = plotVOISE([], params, -1);

if params.movDiag, % init movie
  set(gcf,'position',params.movPos);
	set(gcf,'DoubleBuffer','on');
	params.mov = avifile([params.oDir 'voise.avi'],'fps',2);
end

[nr, nc] = size(params.W);
ns       = params.iNumSeeds;
clipping = params.pcClipping;
radfluct = params.radFluct;

if exist('initSeeds') & isa(initSeeds, 'function_handle'),
  [initSeeds, msg] = fcnchk(initSeeds);
  VDlim = setVDlim(nr,nc,clipping);
  S = initSeeds(nr, nc, ns, VDlim);
  if ~isempty(radfluct),
    S = shakeSeeds(S,nr,nc,VDlim,radfluct);
  end
else
  error('initSeeds not defined or not a Function Handle');
end

% Initialise VD
IVD = computeVDFast(nr, nc, S, VDlim);
% save 
save([params.oDir params.oMatFile], '-append', 'IVD'); 
% plot 
params = plotVOISE(IVD, params, 0);

% Dividing phase 
[DVD, params] = divideVDFast(IVD, params);
% save 
save([params.oDir params.oMatFile], '-append', 'DVD'); 
% plot
params = plotVOISE(DVD, params, 1);

% if movie on do not change figure
if ~params.movDiag, vd1 = figure; end

% Merging phase
[MVD, params] = mergeVDFast(DVD, params);
% save 
save([params.oDir params.oMatFile], '-append', 'MVD');
% plot
params = plotVOISE(MVD, params, 2);

% if movie on do not change figure
if ~params.movDiag, vdc = figure; end

% Regularisation phase
CVD = getCentroidVDFast(MVD, params);
% save
save([params.oDir params.oMatFile], '-append', 'CVD');
% plot
params = plotVOISE(CVD, params, 3);
% do not plot Voronoi diagram 
params = plotVOISE(CVD, params, 4);

% if movie on close movie
if params.movDiag,
  params.mov = close(params.mov);
end

