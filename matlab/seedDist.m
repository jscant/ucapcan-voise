function seedDist(VD,params)
% function seedDist(VD,params)

%
% $Id: seedDist.m,v 1.9 2015/02/11 16:27:46 patrick Exp $
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

% % scaling factors from VD to image axes

global axesParams

W = VD.W;

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

set(gcf, 'Position', axesParams.fig_params);

left = axesParams.left;
bottom = axesParams.bottom;
width = axesParams.ax_width;
height = axesParams.ax_height;



sx = (max(params.x)-min(params.x))/(W.xM-W.xm);
sy = (max(params.y)-min(params.y))/(W.yM-W.ym);

X = (VD.Sx(VD.Sk)-W.xm)*sx+min(params.x);
Y = (VD.Sy(VD.Sk)-W.ym)*sy+min(params.y);

%subplot(111);
plot(X,Y,'ko', 'markersize', 0.35, 'MarkerFaceColor', 'k')
xlabel(sprintf('x [%s]',params.pixelUnit{1}))
ylabel(sprintf('y [%s]',params.pixelUnit{2}))
title('Seeds spatial distribution')

axis equal
%axis off
set(gca,'clim',params.Wlim);
%colorbar
set(gca,'xlim', params.xlim, 'ylim', params.ylim);
ax = gca;
%ax.Position = [left bottom width height];


dpi = strcat('-r', num2str(params.dpi));
print([params.oDir 'seeddist1'], '-depsc', dpi);
print([params.oDir 'seeddist1'], '-dpdf', dpi);

R = sqrt(X.^2+Y.^2);
T = atan2(Y,X)*180/pi;

if ~strcmp(params.pixelUnit{1},params.pixelUnit{2}),
  fprintf('WARNING!!!! pixelUnit different in the x and y directions\n')
end

clf 
subplot(111)
plot(R,T,'o')
if ~strcmp(params.pixelUnit{1},params.pixelUnit{2}),
  fprintf('WARNING!!!! pixelUnit different in the x and y directions\n')
	xlabel(sprintf('\\rho (watch out Unit)'));
	ylabel(sprintf('\\theta (watch out Unit)'));
else
  xlabel(sprintf('\\rho [%s]',params.pixelUnit{1}))
  h=ylabel('\theta [deg]'); %,'VerticalAlignment','top');
  %set(h)
end
title('Seeds spatial distribution')


ri = linspace(0,1.1*max(R),30);
ti = linspace(-90,90,80);

[Ri,Ti] = meshgrid(ri,ti);

Hi = zeros(size(Ri));

for i=1:length(ti)-1,
  for j=1:length(ri)-1,
	  Hi(i,j) = length(find(R>=Ri(i,j) & R<Ri(i+1,j+1) & ...
		                      T>=Ti(i,j) & T<Ti(i+1,j+1)));
	end
end

printFigure(gcf,[params.oDir 'seeddist2.eps']);

return


%title(sprintf('Seeds: %d', length(VD.Sk)))
%print([params.oDir 'seeddist'], "-depsc", '-r1000');
  
printFigure(gcf,[params.oDir 'seeddist.eps']);

return 

subplot(313)
%imagesc(ti,ri,Hi')
pcolor(Ti',Ri',Hi'), shading interp
axis xy
%colorbar
return

hist(T,ti),pause
hist(R,ri),pause
