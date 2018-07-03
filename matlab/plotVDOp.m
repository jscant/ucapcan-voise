function plotVDOp(VD, W, op, varargin)
% function plotVDOp(VD, W, op, varargin)

%
% $Id: plotVDOp.m,v 1.5 2018/06/04 14:49:34 patrick Exp $
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

clim = [min(W(:)) max(W(:))];

%VDW = getVDOp(VD, W, @(x) median(x));
VDW = getVDOp2(VD, W, op, varargin{:});
subplot(211),
imagesc(W),
axis xy,
set(gca,'clim',clim);
colorbar

subplot(212),
% trick to display NaN in imagesc as background 
imagesc(VDW,'AlphaData',~isnan(VDW)),
axis xy,
set(gca,'clim',clim);
colorbar

hold on
[vx,vy]=voronoi(VD.Sx(VD.Sk), VD.Sy(VD.Sk));
% plot Voronoi edges
plot(vx,vy,'-k','LineWidth',0.5)
% plot seeds
plot(VD.Sx(VD.Sk), VD.Sy(VD.Sk),'ko','MarkerSize',2)
hold off

[op,msg] = fcnchk(op);
fprintf(1,'Image processed with %s over Voronoi Diagram\n', func2str(op))

%pause


