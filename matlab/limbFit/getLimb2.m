function fit = getLimb2(VD,params,fit)
% function fit = getLimb2(VD,params,fit)

%
% $Id: getLimb2.m,v 1.8 2015/12/04 15:56:04 patrick Exp $
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

% Calculate equivalent scale length from VD as sqrt(S)
[imls, Sls] = getVDOp(VD, params.W, @(x) sqrt(length(x)));
fprintf('min(Sls) %.2f max(Sls) %.2f\n', [min(Sls), max(Sls)]);

% image coordinate axes
x = params.x;
y = params.y;

% coordinates min, max
xm = min(x); xM = max(x);
ym = min(y); yM = max(y);

% images indices min, max
if isfield(VD,'xm'), % old API pre v1.2
  im = VD.xm; iM = VD.xM;
  jm = VD.ym; jM = VD.yM;
else, % new API
  im = VD.W.xm; iM = VD.W.xM;
  jm = VD.W.ym; jM = VD.W.yM;
end

% convert from image pixel indices to coordinates
Sx = (VD.Sx-im)/(iM-im)*(xM-xm)+xm;
Sy = (VD.Sy-jm)/(jM-jm)*(yM-ym)+ym;


% embed Sx,Sx,Sls in fit
fit.Sx  = Sx(VD.Sk);
fit.Sy  = Sy(VD.Sk);
fit.Sls = Sls;

if strcmp(func2str(fit.model{1}),'ellipse4'),
  fit = selectSeeds2(fit,Sx,Sy,Sls);
else
  fit = selectSeeds(fit,Sx,Sy,Sls);
end

% Removed unselected seeds
Sx = Sx(fit.iSelect);
Sy = Sy(fit.iSelect);
Sls = Sls(fit.iSelect);

if strcmp(func2str(fit.model{1}),'ellipse4'),
  plotSelectedSeeds2(VD,params,fit);
else
  plotSelectedSeeds(VD,params,fit);
end
pause


% Calculate VD statistics 
[S,xc,xy,md2s,md2c] = getVRstats(VD, params, fit.iSelect);
fprintf('min(Sls) %.2f max(Sls) %.2f\n', [min(Sls), max(Sls)]);
fprintf('min(Sls) %.2f max(Sls) %.2f\n', [min(sqrt(S)), max(sqrt(S))]);

Sls = sqrt(S);
% weight are proportional to 1/sqrt(var) 
% where var is a measure of the variance 
% or spread of the polygon
% W = sqrt(2)./Sls;
% spread around an equivalent uniform square
%W = sqrt(6)./Sls;
% spread around an equivalent uniform disc
%W = sqrt(2*pi)./Sls;
% ``exact'' estimates of the spread around the seed
W = 1./md2s;
fit = fitLimb2(fit,Sx,Sy,W);

% convert image coordinates to pixel indices
fit.pxc = (fit.p(1)-xm)/(xM-xm)*(iM-im)+im;
fit.pyc = (fit.p(2)-ym)/(yM-ym)*(jM-jm)+jm;

fprintf(1,'Ellipse(s) centre %8.2f, %8.2f [pixels]\n', fit.pxc,fit.pyc);

