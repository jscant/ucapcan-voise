function plotLimbFit(params,fit1,fit2)
% function plotLimbFit(params,fit1,fit2)

%
% $Id: plotLimbFit.m,v 1.6 2012/04/16 15:45:15 patrick Exp $
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

imagesc(params.x,params.y,params.Wo);
axis xy
axis equal
axis tight

hold on

pp = 1:length(fit1.p0);

[x0,y0] = disc(fit1.p0);

[x1,y1] = disc(fit1.p(pp));

[x2,y2] = disc(fit2.p(pp));

h = plot(x0,y0,'k-.',x1,y1,'k--',x2,y2,'k-');
set(h,'linewidth',1)
legend('guess','fit1','fit2')
if length(fit1.p0) == 3,
  [legh,objh,oh,om] = legend( ...
  sprintf('init C=(%.0f,%.0f) R=%.0f',fit1.p0), ...
  sprintf('fit1 C=(%.0f\\pm%.1g,%.0f\\pm%.1g) R=%.0f\\pm%.1g',[fit1.p(pp),fit1.psd(pp)]'), ...
  sprintf('fit2 C=(%.0f\\pm%.1g,%.0f\\pm%.1g) R=%.0f\\pm%.1g',[fit2.p(pp),fit2.psd(pp)]'));
	set(objh(1),'fontsize',9);
	%title(sprintf('C=(%.0f,%.0f) R=%.0f',fit2.p));
elseif length(fit1.p0) == 5,
  [legh,objh,oh,om] = legend(...
  sprintf('init C=(%.0f,%.0f) a=%.0f b=%.0f \\theta=%.0f',fit1.p0), ...
  sprintf('fit1 C=(%.0f\\pm%.1g,%.0f\\pm%.1g) a=%.0f\\pm%.1g b=%.0f\\pm%.1g \\theta=%.0f\\pm%.1g',[fit1.p(pp),fit1.psd(pp)]'), ...
  sprintf('fit2 C=(%.0f\\pm%.1g,%.0f\\pm%.1g) a=%.0f\\pm%.1g b=%.0f\\pm%.1g \\theta=%.0f\\pm%.1g',[fit2.p(pp),fit2.psd(pp)]'));
	set(objh(1),'fontsize',9);
	%title(sprintf('C=(%.0f,%.0f) a=%.0f b=%.0f \\theta=%.0f',fit2.p));
end

hold off
