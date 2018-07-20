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
if params.printVD
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
[m, n] = size(params.W);
if min(m, n) < 500
    rat = m/n;
    if m > n
        m = 500*rat;
        n = 500;
    else
        m = 500;
        n = 500/rat;
    end
end
    
set(gcf, 'Position', [400, 300, n, m]);
ax = gca;
ti = ax.TightInset;
outerpos = ax.OuterPosition;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - (ti(1) + ti(3));
ax_height = outerpos(4) - (ti(2) + ti(4));

ax.Position = [left+0.02 bottom+0.02 ax_width-0.065 ax_height-0.065];

dpi = strcat('-r', num2str(params.dpi));

if isempty(VD) % original image
  title('Original image')
  print([params.oDir 'orig'], '-depsc', dpi);
else
  title(sprintf('Seeds: %d', length(VD.Sk)))
  print([params.oDir 'phase' num2str(ic)], "-depsc", dpi);
  %printFigure(gcf,[params.oDir 'phase' num2str(ic) '.eps']);
end

if params.movDiag
  movieHandler(params,'addframe');
end
end
