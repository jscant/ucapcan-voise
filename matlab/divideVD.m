function [VD, params]  = divideVD(VD, params)
% function [VD,params] = divideVD(VD, params)

%
% $Id: divideVD.m,v 1.15 2015/02/11 16:13:48 patrick Exp $
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

% miscellaneous information about VOISE
global voise timing

% do not attempt to divide if dividePctile < 0
if params.dividePctile<0,
  return;
else
  dividePctile = params.dividePctile;
end

%if params.divideAlgo == 2 && exist([voise.root '/share/VOISEtiming.mat'],'file'),
%  timing = load([voise.root '/share/VOISEtiming.mat']);
%end

fprintf(1,'*** Starting dividing phase\n')

iDiv = 1;
stopDiv = false;
useOld = 0;
useBatch = 1;
while ~stopDiv,

  % compute homogeneity fuunction and dynamic threshold
  [WD,SD,WHC,SHC,HCThreshold] = computeHCThreshold(VD, params, dividePctile);

  if 0, % diagnostic plot (histogram)
    subplot(211),
    edges = linspace(min(SHC),max(SHC),10);
    n = histc(SHC,edges); bar(edges, cumsum(n)/sum(n)*100, 'histc')
    %pause
	end

  S = ones(0,2);
  for sk = VD.Sk(find(SHC >= HCThreshold))', 
	  % check only the nonhomogeneous Voronoi regions
    s = addSeedsToVR(VD, sk, params);
    S = [[S(:,1); s(:,1)], [S(:,2); s(:,2)]];
  end
	
	if 1, % diagnostic plot (seed to add)
    subplot(212),
    imagesc(WHC);
    axis xy, colorbar
    hold on
    for i=1:size(S,1),
      plot(S(i,1), S(i,2), 'ok', 'MarkerSize', 5);
    end
    hold off
    %pause
	end

	% save homogeneity function and dynamic threshold
	divSHC{iDiv} = SHC;
	divHCThreshold(iDiv) = HCThreshold;
  if ~isempty(S),
	  nSa = size(S,1);
    fprintf(1,'Iter %2d Adding %d seeds to Voronoi Diagram\n', iDiv, nSa)
    params.divideAlgo = 0;
		switch params.divideAlgo % ALWAYS USE INCREMENTAL SKIZ ALGO - REMOVE THIS LATER @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
            case 0 % incremental
                if useBatch
                    Sk = [];
                    for k=1:nSa
                        if isempty(find(S(k,1)==VD.Sx & S(k,2)==VD.Sy))
                            [m,n] = size(Sk);
                            if m == 0
                                Sk = [Sk; S(k,:)];
                            elseif isempty(find(S(k, 1)==Sk(:, 1) & S(k,2)==Sk(:,2)))
                                Sk = [Sk; S(k,:)];
                            end
                        end
                    end
                    VD = addSeedToVDBatch(VD, Sk);
                else
                for k = 1:nSa
                    if isempty(find(S(k,1)==VD.Sx & S(k,2)==VD.Sy))
                       if 0
                            drawVD(VD);
                       end
                    tStart = tic;
                    if useOld
                        VD = addSeedToVD2(VD, S(k,:));
                    else
                        VD = addSeedToVD(VD, S(k,:));
                    end
                    end
                end
                end
			case 1 % full
                for k = 1:nSa,
                    if isempty(find(S(k,1)==VD.Sx & S(k,2)==VD.Sy)),
                        VD.Sx = [VD.Sx; S(k,1)];
						VD.Sy = [VD.Sy; S(k,2)];
					end
				end
				VD = computeVDFast(VD.nr, VD.nc, [VD.Sx, VD.Sy], VD.S);

			case 2 % timing based
                ns = length(VD.Sk);
                tf = polyval(timing.ptVDf, ns+nSa);
				ti = sum(polyval(timing.ptVDa, ns+[0:nSa-1]));
				fprintf(1,'Est. time full(%4d:%4d)/inc(%4d:%4d) %6.1f/%6.1f s ', ...
				        1, ns+nSa, ns+1, ns+nSa, tf, ti);
				tStart = tic;
				if tf < ti % full faster than incremental
                    for k = 1:size(S,1)
                        if isempty(find(S(k,1)==VD.Sx & S(k,2)==VD.Sy))
                            VD.Sx = [VD.Sx; S(k,1)];
                              VD.Sy = [VD.Sy; S(k,2)];
                        end
                    end
                    VD = computeVDFast(VD.nr, VD.nc, [VD.Sx, VD.Sy], VD.S);
                else % incremental faster than full
                    for k = 1:size(S,1)
                        if isempty(find(S(k,1)==VD.Sx & S(k,2)==VD.Sy))
                            VD = addSeedToVD(VD, S(k,:));
                        end
                    end
                end
				fprintf(1,'(Used %6.1f s)\n', toc(tStart));
        end
        %params = plotCurrentVD(VD, params, iDiv);
        iDiv = iDiv+1;
    %fprintf(1,'Voronoi Diagram computed\n');
  else
    disp("StopDiv = True");
    stopDiv = true;
  end
	if 0, % diagnostic plot
    drawVD(VD);
    %pause
	end

  if 0, % NEEDS WORK does not seem to converge
	% compute centre-of-mass of polygons
	p = params; p.regMaxIter = 1;
	VD = getCentroidVD(VD, p);
  end
end

VD.divSHC = divSHC;
VD.divHCThreshold = divHCThreshold;

fprintf(1,'*** Dividing phase completed.\n')

function params = plotCurrentVD(VD, params, iDiv)

if 0
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
colormap(params.colormap);

hold on
[vx,vy]=voronoi(VD.Sx(VD.Sk), VD.Sy(VD.Sk));
plot(vx,vy,'-k','LineWidth',0.5)
hold off

title(sprintf('card(S) = %d  (iteration %d)', length(VD.Sk), iDiv))

drawnow
 
if params.divideExport,
  printFigure(gcf,[params.oDir 'div' num2str(iDiv) '.eps']);
end

if params.movDiag,
  movieHandler(params,'addframe');
end
end
