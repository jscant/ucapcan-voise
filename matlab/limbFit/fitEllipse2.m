function p = fitEllipse2(VD,params,LSS,Sx,Sy,ii,p0,dp)
% function p = fitEllipse2(VD,params,LSS,Sx,Sy,ii,p0,dp)

%
% $Id: fitEllipse2.m,v 1.4 2012/04/16 15:45:15 patrick Exp $
%
% Copyright (c) 2010-2012 Patrick Guio <patrick.guio@gmail.com>
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

global datapath ploc

% convert cartesian into polar coordinates
R = sqrt(Sx(ii).^2+Sy(ii).^2)';
T = 180/pi*atan2(Sy(ii),Sx(ii))';

m = length(ii);

% arrange as [X;Y]
XY = [Sx(ii)'; Sy(ii)'];


fracprec = [zeros(5,1); zeros(m,1)];
fracchg=[Inf*ones(5,1); Inf*ones(m,1)];
options=[fracprec fracchg];

stol = 1e-15;
niter=100;
if ~exist('dp') | isempty(dp),
  % default do not fit tilt angle
  dp = [1, 1, 1, 1, 0, ones(1,m)];
else
  dp = [dp, ones(1,m)];
end

p0 = [p0, T'*pi/180];

W = ones(size(XY));
W = [(1./LSS(ii)');(1./LSS(ii)')];

[f,p,kvg,iter,corp,covp,covr,stdresid,Z,r2,ss] =...
  leasqr(XY, XY, p0, 'ellipse2', stol , niter, W, dp,...
	  'dellipse2',options);

% degrees of freedom
nu = length(f) - length(p(dp==1));
% reduced chi2 statistic
chi2 = ss/(nu-1);
% standard deviation for estimated parameters 
psd = zeros(size(p));
sd = sqrt(diag(covp));
psd(dp==1) = sd;

fprintf(1,'status %d iter %d r2 %.2f chi2 %f\n', kvg, iter, r2, chi2);
fprintf(1,'params est.: Xc(%.1f,%.1f) a=%.1f b=%.1f tilt=%.0f\n', p(1:5));
fprintf(1,'stdev  est.: Xc(%.1f,%.1f) a=%.1f b=%.1f tilt=%.0f\n', psd(1:5));

td = linspace(-180,180,50);

r0 = ellipse(td,[p0(1:4), 180/pi*p0(5)]);
r = ellipse(td,[p(1:4); 180/pi*p(5)]);

%subplot(212)
clf
if ~isempty(params),
  figure(1)
	clf
else
  subplot(211)
end

plot(T,R,'o',td,r0,'-',td,r,'-');
set(gca,'ylim',[0 400],'xlim',[-180 180]);
xlabel('\theta [deg]');
ylabel('\rho [pixels]')

pause

[legh,objh,oh,om] = legend('data','initial','fitted','location','SouthEast');
set(objh(1),'fontsize',9);

return
if ~isempty(datapath) & ~isempty(ploc),

  orient landscape, set(gcf,'PaperOrientation','portrait');
  exportfig(gcf,[datapath '/phasloc' num2str(ploc) '.eps'],...
            'color','cmyk','boundscode','mcode','LockAxes',0);

  ploc = ploc+1;

end


%subplot(222)

if ~isempty(params),
  imagesc(params.x,params.y,params.W);
  axis xy
  axis equal
  axis tight
  xlabel('x [pixels]')
  ylabel('y [pixels]')
  hold on
else
  figure(2)
	clf
  hold on
end

Ts = sort(T);
r0 = ellipse(Ts,p0);
r = ellipse(Ts,p);

Xe = r.*cosd(Ts);
Ye = r.*sind(Ts);

Xe0 = r0.*cosd(Ts);
Ye0 = r0.*sind(Ts);

% initial guess and fitted 
plot(Xe0,Ye0,'r--o', Xe,Ye, 'r-o','linewidth',1)
% data points
plot(Sx(ii), Sy(ii), 'ko','markersize',3);

if ~isempty(VD) & ~isempty(params),
  x = params.x;
  y = params.y;
  line([p(1), p(1)],[min(params.y),max(params.y)],'color','w');
  line([min(params.x),max(params.x)],[p(2), p(2)],'color','w');
  [vx,vy]=voronoi(VD.Sx(VD.Sk), VD.Sy(VD.Sk));
  vx = (vx-min(VD.Sx))/(max(VD.Sx)-min(VD.Sx))*(max(x)-min(x))+min(x);
  vy = (vy-min(VD.Sy))/(max(VD.Sy)-min(VD.Sy))*(max(y)-min(y))+min(y);
  plot(vx,vy,'-k','LineWidth',0.5)
end
title(sprintf('X_c(%.1f,%.1f) a=%.1f b=%.1f', p([1:4])))

hold off

if ~isempty(datapath) & ~isempty(ploc),

  orient landscape, set(gcf,'PaperOrientation','portrait');
  exportfig(gcf,[datapath '/phasloc' num2str(ploc) '.eps'],...
            'color','cmyk','boundscode','mcode','LockAxes',0);

  ploc = ploc+1;

end
