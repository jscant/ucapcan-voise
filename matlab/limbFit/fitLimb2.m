function fit = fitLimb2(fit,Sx,Sy,Sw)
% function fit = fitLimb2(fit,Sx,Sy,Sw)
% 
% fit: structure that can be initialised by getDefaultFitParams
% Sx,Sy: measurements, i.e. Cartesian coordinates of seeds 
% Sw: errors on location of seeds, i.e. spread of the Voronoi region 
% around the seed


%
% $Id: fitLimb2.m,v 1.14 2015/12/04 15:56:04 patrick Exp $
%
% Copyright (c) 2009-2015 Patrick Guio <patrick.guio@gmail.com>
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

global verbose

% seeds position from Cartesian coordinates to polar coordinates
% column vector of observed values
Rs = sqrt(Sx(:).^2+Sy(:).^2);
% column vector or matrix of independent variables
Ts = 180/pi*atan2(Sy(:),Sx(:));

% arrange measurement, i.e. seed position (X,Y) as
% a single column vector with all X's followed by Y's
XY = [Sx(:); Sy(:)];

% number of measurements
ms = length(Sx(:));

% column vector of statistical weights 
if ~exist('Sw') | isempty(Sw),
  % constant=1 if none provided
  Ws = [ones(size(Rs));ones(size(Rs))];
else
  % proportional to 1/sqrt(var)
  Ws = [Sw(:);Sw(:)];
end

fprintf(1,'*** %d parameters fit\n', length(fit.p0));
switch length(fit.p0),
  case 3,
    [xc,yc,r,a] = circfit(Sx,Sy);
	  fprintf(1,'* circfit            Xc(%8.1f,%8.1f) R=%8.1f\n', xc,yc,r);
	  Par = CircleFitByTaubin([Sx(:),Sy(:)]);
	  fprintf(1,'* CircleFitByTaubin  Xc(%8.1f,%8.1f) R=%8.1f\n', Par);
  case 5,
if 0
  p = ellipse_fit(Sx, Sy);
  fprintf(1,'* ellipse_fit        Xc(%8.1f,%8.1f) a=%8.1f b=%8.1f t=%8.2f\n',p);
  [A,p] = EllipseFitByTaubin([Sx(:),Sy(:)]);
  fprintf(1,'* EllipseFitByTaubin Xc(%8.1f,%8.1f) a=%8.1f b=%8.1f t=%8.2f\n',p);
  [A,p] = EllipseDirectFit([Sx(:),Sy(:)]);
  fprintf(1,'* EllipseDirectFit   Xc(%8.1f,%8.1f) a=%8.1f b=%8.1f t=%8.2f\n',p);
end
    a = fit.p0(3);
    if strcmp(func2str(fit.model{1}),'ellipse3'),
	  e = fit.p0(4);
	  b = a*sqrt(1-e^2);
		else
	  b = fit.p0(4);
	  e = sqrt((a^2 - b^2)/a^2);
		end
	  % correct angle for eccentricity
	  Ts = 180/pi*atan2(Sy(:),Sx(:)*sqrt(1-e^2));
  case 8,
	  global iModels
	  iModels = fit.iModels;
	  p = pause; pause on
	  To = Ts;
	  for i=1:2,
		  a{i} = fit.p0(3+(i-1)*3);
	    e{i} = fit.p0(4+(i-1)*3);
		  b{i} = a{i}*sqrt(1-e{i}^2);
		  % correct angle for eccentricity
			im = iModels==i;
	    Ts(im) = 180/pi*atan2(Sy(im),Sx(im)*sqrt(1-e{i}^2));
		  if 0
		    plot(To(im),pi/180*Ts(im),'o')
		    fprintf(1,'press a key to continue...\n'); pause
		  end
	  end
if 0,
	for i=1:ms,
	  plot([0,Sx(i)],[0,Sy(i)],'-x',...
         [0,R(i)*cosd(To(i))],[0,R(i)*sind(To(i))],'-o',...
		     [0,R(i)*cosd(Ts(i))],[0,R(i)*sind(Ts(i))],'-x',...
				 [0,a{iModels(i)}*cosd(Ts(i))],[0,b{iModels(i)}*sind(Ts(i))],'-o');
		axis square
		legend({'1','2','3','4'})
		fprintf(1,'press a key to continue...\n'); pause
	end
end
if 0
	fit.model{1}(XY,[fit.p0(:); To(:)*pi/180]);
	figure
	fit.model{1}(XY,[fit.p0(:); To(:)*pi/180]);
	disp('ModelFun')
	fprintf(1,'press a key to continue...\n'); pause
end
  pause(p);
end

% column vector of initial parameters, angles are in radians
p0 = [fit.p0(:); Ts(:)*pi/180];

% model function
modelFun = fit.model{1};
% direct function jacobian
modelJac = fit.model{2};

% leasqr control parameters
stol     = fit.stol;
niter    = fit.niter;
dp       = [fit.dp(:); ones(ms,1)] ;
fracprec = [fit.fracprec; zeros(ms,1)];
fracchg  = [fit.fracchg; Inf*ones(ms,1)];
options  = [fracprec, fracchg];

verbose  = fit.verbose;

[f,p,kvg,iter,corp,covp,covr,stdresid,Z,r2,ss] = ...
  leasqr(XY, XY, p0, modelFun, stol, niter, Ws, dp, modelJac, options);

% degrees of freedom
nu = length(f) - length(p(dp==1));
% reduced chi2 statistic
chi2 = ss/(nu-1);
% standard deviation for estimated parameters 
psd = zeros(size(p));
sd = sqrt(diag(covp));
psd(dp==1) = sd;

% embed data in fit structure
fit.t = Ts;
fit.r = Rs;
fit.w = Ws;

% embed fit results in fit structure
fit.status = kvg;      % = 1 if convergence, = 0 otherwise
fit.iter   = iter;     % number of iterations used
fit.p      = p;        % trial or final parameters. i.e, the solution
fit.psd    = psd;      % standard deviation for estimated parameters
fit.corp   = corp;     % correlation matrix for parameters
fit.covp   = covp;     % covariance matrix of the parameters
fit.covr   = covr;     % diag(covariance matrix of the residuals)
fit.stdres = stdresid; % standardized residuals (res-m)/sd
fit.Z      = Z;        % matrix that defines confidence region 
fit.r2     = r2;       % coefficient of multiple determination
fit.ss     = ss;       % scalar sum of squares=sum-over-i(wt(i)*(y(i)-f(i)))^2
fit.nu     = nu;       % degrees of freedom
fit.chi2   = chi2;     % reduced chi2 statistic

fprintf(1,'status %d iter %d r2 %.2f chi2 %f\n', kvg, iter, r2, chi2);

switch length(fit.p0),

  case 3,
    fprintf(1,'params Xc(%8.1f,%8.1f) R=%8.1f\n', p(1:3));
    fprintf(1,'stdev  Xc(%8.1f,%8.1f) R=%8.1f\n', psd(1:3))

	case 5,
  % eccentricity parametrisation
  if strcmp(func2str(fit.model{1}),'ellipse3'),
    fprintf(1,'params Xc(%8.1f,%8.1f) a=%8.1f e=%8.4f t=%8.4f\n', p(1:5));
    fprintf(1,'stdev  Xc(%8.1f,%8.1f) a=%8.1f e=%8.4f t=%8.4f\n', psd(1:5))
    a = p(3);
    e = p(4);
    p(4) = a * sqrt(1-e^2);
    da = psd(3);
    de = psd(4);
    % b^2 = a^2(1-e^2)
    % 2b db = 2a da (1-e^2) -a^2 2 e de 
    % db^2 = 1/4b^2 [4 a^2 (1-e^2)^2 da^2 + a^4 4 e^2 de^2
    % db^2 = a^2/b^2(1-e^2)^2 da^2 + a^4/b^2e^2 de^2
    % db^2 = (1-e^2) da^2 + a^2/(1-e^2)de^2
    psd(4) = sqrt((1-e^2)*da^2+e^2*a^2/(1-e^2)*de^2);
    fit.p = p;
    fit.psd = psd;
  end
  fprintf(1,'params Xc(%8.1f,%8.1f) a=%8.1f b=%8.1f t=%8.4f\n', p(1:5));
  fprintf(1,'stdev  Xc(%8.1f,%8.1f) a=%8.1f b=%8.1f t=%8.4f\n', psd(1:5))

  case 8,
  fprintf(1,'params Xc(%8.1f,%8.1f) a=%8.1f e=%8.4f t=%8.4f\n', p(1:5));
	fprintf(1,'                             a=%8.1f e=%8.4f t=%8.4f\n', p(6:8));
  fprintf(1,'stdev  Xc(%8.1f,%8.1f) a=%8.1f e=%8.4f t=%8.4f\n',psd(1:5));
	fprintf(1,'                             a=%8.1f e=%8.4f t=%8.4f\n',psd(6:8));
    a = p(3);
    e = p(4);
    p(4) = a * sqrt(1-e^2);
    da = psd(3);
    de = psd(4);
    psd(4) = sqrt((1-e^2)*da^2+e^2*a^2/(1-e^2)*de^2);
    a = p(6);
    e = p(7);
    p(7) = a * sqrt(1-e^2);
    da = psd(6);
    de = psd(7);
    psd(7) = sqrt((1-e^2)*da^2+e^2*a^2/(1-e^2)*de^2);
		if 0
    fit.p = p;
    fit.psd = psd;
		end
  fprintf(1,'params Xc(%8.1f,%8.1f) a=%8.1f b=%8.4f t=%8.4f\n', p(1:5));
	fprintf(1,'                             a=%8.1f b=%8.4f t=%8.4f\n',p(6:8));
  fprintf(1,'stdev  Xc(%8.1f,%8.1f) a=%8.1f b=%8.4f t=%8.4f\n',psd(1:5));
	fprintf(1,'                             a=%8.1f b=%8.4f t=%8.4f\n',psd(6:8));
end

% fitted angles
phis = p(length(fit.p0)+1:end);
fprintf(1,' phi mean, min, max       =%8.4f, %8.4f, %8.4f\n', ...
        mean(phis), min(phis), max(phis) );
% and errors on fitted angles
phis = psd(length(fit.p0)+1:end);
fprintf(1,'dphi mean, min, max       =%8.4f, %8.4f, %8.4f\n', ...
        mean(phis), min(phis), max(phis) );


ix = 1:ms; iy = ms+1:ms+ms;
if length(fit.p0)==3,
  % compute r
  xy = circle2(XY,fit.p);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	r = sqrt(x.^2+y.^2);
	% compute distance to seed
	d2seed = sqrt((x-Sx).^2+(y-Sy).^2);
	% compute dr
	xy = circle2(XY,fit.p-[0;0;fit.psd(3);zeros(ms,1)]);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	rm = sqrt(x.^2+y.^2);
	xy = circle2(XY,fit.p+[0;0;fit.psd(3);zeros(ms,1)]);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	rM = sqrt(x.^2+y.^2);
	dr = rM-rm;
	% compute dtheta
	xy = circle2(XY,fit.p-[zeros(3,1);fit.psd(4:end)]);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	tm = atan2(y,x);
	xy = circle2(XY,fit.p+[zeros(3,1);fit.psd(4:end)]);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	tM = atan2(y,x);
	dt = tM-tm;
	% fix the angles that might be wrongly interpreted
	dt(dt<0) = dt(dt<0)+2*pi;
	% compute infinitesimal volume rdrdtheta
  dS = r.*dr.*dt;
elseif length(fit.p0)==5,
  % compute r
  xy = ellipse2(XY,fit.p);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	r = sqrt(x.^2+y.^2);
	% compute distance to seed
	d2seed = sqrt((x-Sx).^2+(y-Sy).^2);
	% compute dr
	xy = ellipse2(XY,fit.p-[0;0;fit.psd(3:4);0;zeros(ms,1)]);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	rm = sqrt(x.^2+y.^2);
	xy = ellipse2(XY,fit.p+[0;0;fit.psd(3:4);0;zeros(ms,1)]);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	rM = sqrt(x.^2+y.^2);
	dr = rM-rm;
	% compute dtheta
	xy = ellipse2(XY,fit.p-[zeros(5,1);fit.psd(6:end)]);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	tm = atan2(y,x);
	xy = ellipse2(XY,fit.p+[zeros(5,1);fit.psd(6:end)]);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	tM = atan2(y,x);
	dt = tM-tm;
	% fix the angles that might be wrongly interpreted
	dt(dt<0) = dt(dt<0)+2*pi;
	% compute infinitesimal volume rdrdtheta
  dS = r.*dr.*dt;
elseif length(fit.p0)==8,
  xy = ellipse4(XY,fit.p);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	r = sqrt(x.^2+y.^2);
	% compute distance to seed
	d2seed = sqrt((x-Sx).^2+(y-Sy).^2);
	% compute dr
	xy = ellipse4(XY,fit.p-[0;0;fit.psd(3:4);0;fit.psd(6:7);0;zeros(ms,1)]);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	rm = sqrt(x.^2+y.^2);
	xy = ellipse4(XY,fit.p+[0;0;fit.psd(3:4);0;fit.psd(6:7);0;zeros(ms,1)]);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	rM = sqrt(x.^2+y.^2);
	dr = rM-rm;
	% compute dtheta
	xy = ellipse4(XY,fit.p-[zeros(8,1);real(fit.psd(9:end))]);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	tm = atan2(y,x);
	xy = ellipse4(XY,fit.p+[zeros(8,1);fit.psd(9:end)]);
	x = xy(ix)-fit.p(1); y = xy(iy)-fit.p(2);
	tM = atan2(y,x);
	dt = tM-tm;
	% fix the angles that might be wrongly interpreted
	dt(dt<0) = dt(dt<0)+2*pi;
	% compute infinitesimal volume rdrdtheta
  dS = r.*dr.*dt;
end

figure
plot(1./Sw, sqrt(dS),'o',1./Sw,d2seed,'s')
axis equal
xlabel('Sls')
legend('sqrt(dS)','d2seed')
pause
close
