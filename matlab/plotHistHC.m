function plotHistHC(DVD, MVD, params)
% function plotHistHC(DVD, MVD, params)

%
% $Id: plotHistHC.m,v 1.7 2012/04/16 16:54:27 patrick Exp $
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

MarkerSize = 4;
if 0,
  method = {'linear','extrap'};
else
  method = {'linear'};
end
interpolate=true;

% original size
pos=get(gcf,'position');

edges = linspace(0,1,30);
edges = [edges, 1+edges(2)-edges(1)];
pctiles = linspace(0,100,40); %[0:2:20 25:5:75 80:2:100];

idiv=[1:6:length(DVD.divSHC)-1];
if idiv(end) < length(DVD.divSHC)-1,
  idiv(end) = length(DVD.divSHC)-1;
end
divCumHist = zeros(length(edges), length(idiv));
divChi = zeros(length(pctiles), length(idiv));
for I=1:length(idiv),
	% i=1 means initialisation 
  i = idiv(I)+1;
  [n,bin] = histc(DVD.divSHC{i}, edges);
  divCumHist(:,I) = cumsum(n)/sum(n)*100;
  divChi(:,I) = prctile(DVD.divSHC{i}, pctiles);
	% fix for identical values in the divChi(:,I) array, remove an epsilon
	ii = find(diff(divChi(:,I)) == 0);
	if ~isempty(ii),
	divChi(ii,I) = divChi(ii,I)-eps;
	end
	hold on 
	bar(edges(2:end),divCumHist(1:end-1,I),'hist');
	plot(edges(2:end),divCumHist(1:end-1,I),'-r');
	plot(divChi(:,I),pctiles,'g-'); hold off; 
	if params.pause, pause, end
	if interpolate,
	% remove identical x values before interpolating
	[uDiv,ui] = unique(divChi(:,I));
	divCumHist(:,I) = interp1(divChi(ui,I), pctiles(ui), edges, method{:});
	divCumHist(~isfinite(divCumHist(:,I))&edges'<=edges(fix(end/2)),I) = 0;
	divCumHist(~isfinite(divCumHist(:,I))&edges'>edges(fix(end/2)),I) = 100;
	end
	divleg{I} = sprintf('i=%3d ns=%3d ', i-1, length(DVD.divSHC{i}));
	fprintf(1,'%s\n', divleg{I});
end

% the chi's of first merging phase (initialisation)  
% are equal to the chi's of last dividing phase
% should return empty!
if ~isempty(find(DVD.divSHC{end}~=MVD.mergeSHC{1})),
  error('Problem here!')
end

if length(MVD.mergeSHC)>1, % merging phases available
  imer=[1,length(MVD.mergeSHC)-1];
  merCumHist = zeros(length(edges), length(imer));
  merChi = zeros(length(pctiles), length(imer));
  for I=1:length(imer),
	% i=1 means initialisation 
  i = imer(I)+1;
  [n,bin] = histc(MVD.mergeSHC{i}, edges);
  merCumHist(:,I) = cumsum(n)/sum(n)*100;
  merChi(:,I) = prctile(MVD.mergeSHC{i}, pctiles);
	if interpolate
	% remove identical x values before interpolating
	[uMer,ui] = unique(merChi(:,I));
	merCumHist(:,I) = interp1(merChi(ui,I), pctiles(ui), edges,method{:});
	end
	merleg{I} = sprintf('i=%3d ns=%3d', i-1, length(MVD.mergeSHC{i}));
	fprintf(1,'%s\n', merleg{I});
  end
else, % contains only initialisation
  imer = [];
	merCumHist = [];
	merChi = [];
	merleg = {};
end

pos1 = [pos(1:2) pos(3) pos(4)];
set(gcf,'position',pos1);

clf
subplot(111), 
if ~interpolate
  edges = [0.5*(edges(1:end-1)+edges(2:end)) edges(end)];
end
if 1
if ~isempty(merCumHist),
plot(edges,divCumHist,'-x',edges,merCumHist,'-d','MarkerSize',MarkerSize)
else
plot(edges,divCumHist,'-x','MarkerSize',MarkerSize)
end
else
if ~isempty(merChi),
plot(divChi,pctiles,'-x',merChi,pctiles,'-d','MarkerSize',MarkerSize)
else
plot(divChi,pctiles,'-x','MarkerSize',MarkerSize)
end
end
xlabel('\chi')
ylabel('Prob(\chi(I,s_i) < \chi) [\times 100 %]')
set(gca,'xlim',[0 1], 'ylim', [0 100])
[legh,objh,outh,outma] = legend(divleg{:},merleg{:},'Location','SouthEast');
%set(objh(1),'fontsize',9);

printFigure(gcf,[params.oDir 'histhc1.eps']);


pos23 = [pos(1:2) pos(3) pos(4)];
set(gcf,'position',pos23);

clf
h=subplot(212);
p = get(h,'position');
set(h,'position',[p(1), p(2), p(3), 1.5*p(4)]);

divX = [0:length(DVD.divHCThreshold)-1];
merX = divX(end)+[1:length(MVD.mergeHCThreshold)-1];
plot(divX, DVD.divHCThreshold(1:end)  , '-x',  ...
     merX, MVD.mergeHCThreshold(2:end), '-d', 'MarkerSize', MarkerSize)
set(gca,'xlim',[0 max([divX(:);merX(:)])], 'ylim', [0 1])
xlabel('Iteration')
ylabel('\chi_m')
if ~isempty(merX), 
legpctile = { sprintf('divide (p_D=%d%%) ',params.dividePctile), ...
              sprintf('merge  (p_M=%d%%) ',params.mergePctile)};
else
legpctile = { sprintf('divide (p_D=%d%%) ',params.dividePctile) };
end
[legh,objh,outh,outma] = legend(legpctile{:}, 'Location', 'NorthEast');
%set(objh(1),'fontsize',9);


printFigure(gcf,[params.oDir 'histhc2.eps']);

clf
h=subplot(212);
p = get(h,'position');
set(h,'position',[p(1), p(2), p(3), 1.5*p(4)]);

divX = [0:length(DVD.divHCThreshold)-1];
idiv = [1:length(DVD.divSHC)];
sdiv = zeros(size(idiv));
for i=idiv,
  sdiv(i) = length(DVD.divSHC{i});
end

merX = divX(end)+[1:length(MVD.mergeHCThreshold)-1];
imer = [1:length(MVD.mergeSHC)-1];
smer = zeros(size(imer));
for i=imer,
  smer(i) = length(MVD.mergeSHC{i+1});
end

plot(divX, sdiv, '-x',  ...
     merX, smer, '-d', 'MarkerSize', MarkerSize)
ymx = ceil(max([sdiv(:);smer(:)])/100)*100;
set(gca,'xlim',[0 max([divX(:);merX(:)])], 'ylim', [0 ymx])
xlabel('Iteration')
ylabel('card(S)')
[legh,objh,outh,outma] = legend(legpctile{:}, 'Location', 'SouthEast');
%set(objh(1),'fontsize',9);


printFigure(gcf,[params.oDir 'histhc3.eps']);

set(gcf,'position',pos);
return


return

%orient landscape
printFigure(gcf,[params.oDir 'histhc.eps']);

