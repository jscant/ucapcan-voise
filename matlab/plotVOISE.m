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

global axesParams

if params.printVD

clf;
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
left = axesParams.left;
bottom = axesParams.bottom;
width = axesParams.ax_width;
height = axesParams.ax_height;

ax.Position = [left bottom width height];

%axis off
set(gca,'clim',params.Wlim);
%colorbar
set(gca,'xlim', params.xlim, 'ylim', params.ylim);
colormap(params.colormap);
set(gcf, 'Position', axesParams.fig_params);

ax = gca;

dpi = strcat('-r', num2str(params.dpi));

if ~isempty(VD)% || 1
  % scaling factors from VD to image axes
  if ~isempty(VD)
      W = VD.W;
      n = W.xM - W.xm;
      m = W.yM - W.ym;
  else
      W = params.W;
      [m, n] = size(W);
  end
  
  sx = (max(params.x)-min(params.x))/(n);
  sy = (max(params.y)-min(params.y))/(m);

  %if ~isempty(VD)
      S = VD.S;
      h = line([S.xm,S.xm,S.xM,S.xM,S.xm],[S.ym,S.yM,S.yM,S.ym,S.ym]);
      set(h,'Color',[.5,.5,.5],'LineWidth',0.05);
  %end
  
  if ic~=4% && ~isempty(VD)
      hold on
      [vx,vy]=voronoi(VD.Sx(VD.Sk), VD.Sy(VD.Sk));
      plot((vx-W.xm)*sx+min(params.x),(vy-W.ym)*sy+min(params.y),...
           '-k','LineWidth',0.5)
      hold off
  end
end

xlabel(sprintf('x [%s]',params.pixelUnit{1}))
ylabel(sprintf('y [%s]',params.pixelUnit{2}))

if isempty(VD) % original image
  title('Original image')
  %print([params.oDir 'orig'], '-depsc', dpi);
  print([params.oDir 'orig'], '-dpdf', dpi);
else
  switch ic
      case 0
          titlestr = 'Initial configuration | ';
      case 1
          titlestr = 'Divide phase | ';
      case 2
          titlestr = 'Merge phase | ';
      case 3
          titlestr = 'Regularisation phase | ';
          load('../clustering/clusters.txt', '-ascii');

  end
  title(sprintf('%sSeeds: %d', titlestr, length(VD.Sk)))
  %print([params.oDir 'phase' num2str(ic)], '-depsc', dpi);
  print([params.oDir 'phase' num2str(ic)], '-dpdf', dpi);
end

if params.movDiag
  movieHandler(params,'addframe');
end
end
