function [VD, params] = mergeVD(VD, params)
% function [VD, params] = mergeVD(VD, params)

%
% $Id: mergeVD.m,v 1.20 2015/02/13 14:55:15 patrick Exp $
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

% do not attempt to merge if mergePctile < 0
if params.mergePctile<0,
  return;
else
  mergePctile = params.mergePctile;
end

%if params.mergeAlgo == 2 && exist([voise.root '/share/VOISEtiming.mat'],'file'),
%  timing = load([voise.root '/share/VOISEtiming.mat']);
%end

% Similarity parameters dmu defined for region i and 
% homogeneous neighbours j
% \mu_i is  median(VR_i) or mean(VR_i)
% |\mu_i-\mu_j|< dmu |\mu_i|, when  \mu_i>a*std(VR_i) 
% |\mu_i-\mu_j|< a*sqrt(std(\mu_i)^2+std(\mu_j)^2), when \mu_i<=a*std(VR_i)
% where a(=ksd) is given
dmu = params.dmu;
ksd = params.ksd;
% non homogeneous neighbours vertices length to circumference max ratio
thresHoldLength = params.thresHoldLength;

fprintf(1,'*** Starting merging phase\n')

iMerge = 1;
stopMerge = false;
while ~stopMerge,

  % compute homogeneity fuunction and dynamic threshold
  [WD,SD,WHC,SHC,HCThreshold] = computeHCThreshold(VD, params, mergePctile);

  if 1,
	  [Wmu, VD.Smu] = getVDOp(VD, params.W, @(x) median(x));
  else
	  [Wmu, VD.Smu] = getVDOp(VD, params.W, @(x) mean(x));
  end
	% sqrt(2)*std(VR_i)
	[Wsdmu, VD.Ssdmu] = getVDOp(VD, params.W, @(x) ksd*std(x));

  if 0, % diagnostic plot
    [vx,vy] = voronoi(VD.Sx(VD.Sk), VD.Sy(VD.Sk));
  end

  % build index table to map values in VD.Nk to their indices 
  IST = zeros(length(VD.Nk),1);
  i=1;
  for in = 1:length(VD.Nk),
    if ~isempty(find(VD.Sk == in)),
	    IST(in) = i;
	    i = i+1;
	  end
  end

  Sk = [];
  for isk = IST(VD.Sk(find(SHC < HCThreshold)))', % For homogeneous VR
    % isk contains indice in array of size number of seeds
	  %  sk contains seed indice in VD.Nk
    sk = VD.Sk(isk);
    if 0,
      fprintf(1,'s=%4d HC=%5.2f (%d) mu=%8.3g HC Threshold=%5.2f\n', ...
		          [sk, SHC(isk),(SHC(isk) < HCThreshold),VD.Smu(isk),HCThreshold]);
	  end
	  % Flag for homogeneous neighbour VR
	  ihc = (SHC(IST(VD.Nk{sk}))' < HCThreshold);
	  if 0,
      fprintf(1,'n=%4d HC=%5.2f (%d) mu=%8.3g\n', ...
	            [VD.Nk{sk}, SHC(IST(VD.Nk{sk})), ihc', VD.Smu(IST(VD.Nk{sk}))]');
	  end
	  % median intensity difference to homogeneous neighbours |\mu_i-\mu_j| 
    err  =  abs(VD.Smu(isk) - VD.Smu(IST(VD.Nk{sk}(ihc)))'); 
    % square root of variance of intensity with homogeneous neighbours
    ssd  = sqrt(VD.Ssdmu(isk).^2 + VD.Ssdmu(IST(VD.Nk{sk}(ihc)))'.^2); 
	  if 0,
	    if ~isempty(err), 
        fprintf(1,'dmu |mu|=%7.2g\n', dmu*abs(VD.Smu(isk)));
	      fprintf(1,'err=');
	      fprintf(1,' %.2g', err); 
        fprintf(1,'\n');
	      fprintf(1,'ssd=');
	      fprintf(1,' %.2g', ssd); 
        fprintf(1,'\n');
	    end
	  end
	  if 0, % diagnostic plot
	    subplot(111)
	    imagesc(Wmu), 
	    set(gca,'clim',params.Wlim);
	    colorbar
	    axis xy, axis equal
	    hold on
	    plot(VD.Sx(sk), VD.Sy(sk), 'xk', 'MarkerSize', 5);
      plot(VD.Sx(VD.Nk{sk}(ihc)), VD.Sy(VD.Nk{sk}(ihc)), 'ok', 'MarkerSize', 5);
			for i=1:length(ihc),
			  text(VD.Sx(VD.Nk{sk}(i)), VD.Sy(VD.Nk{sk}(i)), ...
				     num2str(VD.Nk{sk}(i)), 'verticalalignment', 'bottom');
			end
	    plot(vx,vy,'-k','LineWidth',0.5)
      hold off
			set(gca,'xlim',[min(VD.Sx(VD.Nk{sk}(:)))-2 max(VD.Sx(VD.Nk{sk}(:)))+2])
			set(gca,'ylim',[min(VD.Sy(VD.Nk{sk}(:)))-2 max(VD.Sy(VD.Nk{sk}(:)))+2])
	    %pause
    end
    if (abs(VD.Smu(isk))>VD.Ssdmu(isk) && all(err<dmu*abs(VD.Smu(isk))))||...
      (abs(VD.Smu(isk))<=VD.Ssdmu(isk) && all(err<ssd)), 
	    % all homogeneous neighbours are less than dmu\% different
      % get vertices list of VR(sk)
		  % unbounded VR not handled properly
      [V,I] = getVRvertices(VD, sk);
      if 0, % diagnostic plot
        hold on
        plot(V(:,1),V(:,2), 'dk', 'MarkerSize', 5);
        for i=1:size(V,1),
          text(V(i,1), V(i,2), num2str(i), 'verticalalignment', 'bottom');
        end
        hold off
      end
		  edgesLength = sqrt(sum((V([1:end],:)-V([2:end 1],:)).^2,2));
			if 0,
        % trick to get the reverse indices of I
        % VD.Nk{sk}(I) sorted neighbour as edgesLength calculated from V
        % edgesLength(revI) sorted as VD.Nk{sk}(:)
        revI = zeros(size(I));
        revI(I) = [1:length(I)]';
        fprintf(1,'verticeSeed='); fprintf(1,' %5d', VD.Nk{sk}(I));
        fprintf(1,'\n');
        fprintf(1,'edgesLength='); fprintf(1,' %5.1f', edgesLength);
        fprintf(1,'\n');
        fprintf(1,'edgesHCflag='); fprintf(1,' %5d', ihc(I));
        fprintf(1,'\n');
			end
	  	totalLength = sum(edgesLength);
			% ihc(I) provides HC flags sorted as edgesLength calculated from V
		  nonHCLength = sum(edgesLength(~ihc(I)));
		  r = nonHCLength/totalLength;
			if 0
		  fprintf(1,'totalLength=%.1f nonHCLength=%.1f ratio=%.2f (max=%.2f)\n',...
			        totalLength, nonHCLength, r, thresHoldLength);
			end
		  if r < thresHoldLength,
			  if 0
		    fprintf(1,'s=%d to be removed\n', sk);
				end
		    Sk = [Sk; sk]; 
		  end
		  %pause
	  end
  end
  %save([params.oDir 'removedSeeds'], 'Sk');

	% save homogeneity function and dynamic threshold
	mergeSHC{iMerge} = SHC;
	mergeHCThreshold(iMerge) = HCThreshold;
  if ~isempty(Sk),
	  nSr = length(Sk);
    fprintf(1,'Iter %2d Removing %d seeds from Voronoi Diagram\n', iMerge, nSr);
    %pause
		switch params.mergeAlgo,
		  case 0, % incremental
        for k = Sk(:)',
          VD  = removeSeedFromVD(VD, k);
					% diagnostic plot
          if 0, drawVD(VD); end
        end
			case 1, % full
			  Skeep = setdiff(VD.Sk, Sk);
				VD = computeVDFast(VD.nr, VD.nc, [VD.Sx(Skeep), VD.Sy(Skeep)],VD.S);
			case 2, % timing based
			  ns = length(VD.Sk);
			  Skeep = setdiff(VD.Sk, Sk);
			  tf = polyval(timing.ptVDf, ns-nSr);
				ti = sum(polyval(timing.ptVDr,ns-[0:nSr-1]));
				fprintf(1,'Est. time full(%4d:%4d)/inc(%4d:%4d) %6.1f/%6.1f s ', ...
				        1, ns-nSr, ns-1, ns-nSr, tf, ti);
				tStart = tic;
				if tf < ti, % full faster than incremental
				  Skeep = setdiff(VD.Sk,Sk);
					VD = computeVDFast(VD.nr, VD.nc, [VD.Sx(Skeep), VD.Sy(Skeep)],VD.S);
				else, % incremental faster than full
          for k = Sk(:)',
            VD  = removeSeedFromVD(VD, k);
          end
				end
				fprintf(1,'(Used %6.1f s)\n', toc(tStart));
		end
    params = plotCurrentVD(VD, params, iMerge);
	  iMerge = iMerge+1;
		%fprintf(1,'Voronoi Diagram computed\n');
  else
    stopMerge = true;
  end
end

fprintf(1,'*** Merging phase completed.\n')

VD.mergeSHC = mergeSHC;
VD.mergeHCThreshold = mergeHCThreshold;

function params = plotCurrentVD(VD, params, iMerge)

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

hold on
[vx,vy]=voronoi(VD.Sx(VD.Sk), VD.Sy(VD.Sk));
plot(vx,vy,'-k','LineWidth',1)
hold off

colormap(params.colormap);

title(sprintf('card(S) = %d  (iteration %d)', length(VD.Sk), iMerge))

drawnow 

if params.mergeExport,
  printFigure(gcf,[params.oDir 'merge' num2str(iMerge) '.eps']);
end

if params.movDiag,
  movieHandler(params, 'addframe');
end

