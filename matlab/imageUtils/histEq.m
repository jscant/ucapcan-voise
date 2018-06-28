function [Y,xbins,cdf] = histEq(X,nbins)
% function [Y,xbins,cdf] = histEq(X,nbins)

%
% $Id: histEq.m,v 1.3 2012/04/16 16:54:15 patrick Exp $
%
% Copyright (c) 2009-2012 Patrick Guio <patrick.guio@gmail.com>
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

% dimension of X
d = size(X);

% extrema
mn = min(X(:));
mx = max(X(:));

fprintf(1,'Range of X [%.3g, %.3g]\n', [mn, mx]);

% histogram of X
[bins,xbins] = hist(X(:),nbins);
% CDF of X
cdf = cumsum(bins)/sum(bins);
fprintf(1,'Range of CDF [%.3g, %.3g]\n', [min(cdf), max(cdf)]);

% linear CDF (uniform  histogram)
cdfl = linspace(0,1,nbins);

if 0
plot(xbins,cdf,xbins,cdfl);
set(gca,'xlim',[mn,mx],'ylim',[0,1]);
title('CDF X');
end

Y = reshape((mx-mn)*interp1(xbins,cdf,X,'linear','extrap')+mn, d);

