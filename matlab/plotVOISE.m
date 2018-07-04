function params = plotVOISE(VD, params, ic)
% function params = plotVOISE(VD, params, ic)

%
% $Id: plotVOISE.m,v 1.7 2015/02/11 16:23:06 patrick Exp $
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
if 0
clf
subplot(111)

x = params.x;
y = params.y;

if isempty(VD) % original image
	W = params.W;
else % median operator on VD
    [W, Sop] = getVDOp(VD, params.W, 1);
  %W = getVDOp2(VD, params.W, @(x) median(x));
end

imagesc(x, y, W),
axis xy,
axis equal
%axis off
set(gca,'clim',params.Wlim);
%colorbar
set(gca,'xlim', params.xlim, 'ylim', params.ylim);
colormap(params.colormap);

if ~isempty(VD)
  % scaling factors from VD to image axes
  W = VD.W;
  sx = (max(params.x)-min(params.x))/(W.xM-W.xm);
  sy = (max(params.y)-min(params.y))/(W.yM-W.ym);

  S = VD.S;
  h = line([S.xm,S.xm,S.xM,S.xM,S.xm],[S.ym,S.yM,S.yM,S.ym,S.ym]);
  set(h,'Color',[.5,.5,.5],'LineWidth',0.05);

  if ic~=4
      hold on
      [vx,vy]=voronoi(VD.Sx(VD.Sk), VD.Sy(VD.Sk));
      plot((vx-W.xm)*sx+min(params.x),(vy-W.ym)*sy+min(params.y),...
           '-k','LineWidth',0.5)
      hold off
  end
end

if isempty(VD) % original image
  title('Original image')
  printFigure(gcf,[params.oDir 'orig.eps']);
else
  title(sprintf('card(S) = %d', length(VD.Sk)))
  printFigure(gcf,[params.oDir 'phase' num2str(ic) '.eps']);
end

if params.movDiag
  movieHandler(params,'addframe');
end
end
