function params = plotDefaultVOISE(VD, params, info)
% function params = plotDefaultVOISE(VD, params, info)

%
% $Id: plotDefaultVOISE.m,v 1.6 2015/02/11 16:24:32 patrick Exp $
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

VDW = getVDOp(VD, params.W, @(x) median(x));

clf
subplot(111),
imagesc(VDW),
axis xy,
axis equal
axis off
set(gca,'clim',params.Wlim);
%colorbar
W = VD.W;
set(gca,'xlim',[W.xm W.xM], 'ylim', [W.ym W.yM]);

hold on
[vx,vy]=voronoi(VD.Sx(VD.Sk), VD.Sy(VD.Sk));
plot(vx,vy,'-k','LineWidth',0.5)
hold off

title(sprintf('card(S) = %d  (iteration %d)', length(VD.Sk), info.iter))

drawnow

if params.divideExport,
  printFigure(gcf,[params.oDir info.name num2str(info.iter) '.eps']);
end

if params.movDiag,
  movieHandler(params,'addframe');
end

