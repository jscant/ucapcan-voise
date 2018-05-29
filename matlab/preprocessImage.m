function params = preprocessImage(params)
% function params = preprocessImage(params)

%
% $Id: preprocessImage.m,v 1.3 2018/03/08 15:49:39 patrick Exp $
%
% Copyright (c) 2015 Patrick Guio <patrick.guio@gmail.com>
% All Rights Reserved.
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 3 of the License, or (at your
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.


params.Wo = params.W;

if length(params.winSize) == 2 && isa(params.filter, 'function_handle'),
  fprintf(1,'filterImage(image, [%d,%d], %s)\n', ...
          params.winSize, func2str(params.filter));
  params.W = filterImage(params.Wo,params.winSize, params.filter);
end

if ~isempty(params.noiseThres),
  fprintf(1,'log10(image) with noiseThres=%f\n', params.noiseThres);
  params.W(params.W<params.noiseThres) = params.noiseThres;
  params.W = log10(params.W);
end


if ~isempty(params.histEqBin),
  fprintf(1,'histEq(image, %d)\n', params.histEqBin);
  [params.W, xbins, cdf] = histEq(params.W, params.histEqBin);
end


