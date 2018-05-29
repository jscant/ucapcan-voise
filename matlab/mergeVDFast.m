function [VD, params] = mergeVDFast(VD, params)
% function [VD, params] = mergeVDFast(VD, params)

%
% $Id: mergeVDFast.m,v 1.8 2015/02/11 16:16:58 patrick Exp $
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

% do not attempt to merge if mergePctile < 0
if params.mergePctile<0,
  return;
else
  mergePctile = params.mergePctile;
end

% Similarity parameters |\mu_i-\mu_j|< dmu \mu_i
dmu = params.dmu;
% non homogeneous neighbours vertices length to circumference max ratio
thresHoldLength = params.thresHoldLength;

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
	  % 
    err  =  abs(VD.Smu(isk) - VD.Smu(IST(VD.Nk{sk}(ihc)))'); 
	  if 0,
	    if ~isempty(err), 
        fprintf(1,'dmu |mu|=%7.2g\n', dmu*abs(VD.Smu(isk)));
	      fprintf(1,'err=');
	      fprintf(1,' %.2g', err); 
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
	  if all(err < dmu*abs(VD.Smu(isk))), 
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
    fprintf(1,'Removing %d seeds from Voronoi Diagram\n', length(Sk));
    %pause
    Skeep = setdiff(VD.Sk,Sk);
    VD = computeVDFast(VD.nr, VD.nc, [VD.Sx(Skeep), VD.Sy(Skeep)], VD.S);
		if 0
    for k = Sk(:)',
      VD  = removeSeedFromVD(VD, k);
      if 0
        drawVD(VD);
	    end
    end
		end
    params = plotCurrentVD(VD, params, iMerge);
	  iMerge = iMerge+1;
  else
    stopMerge = true;
  end
end

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

title(sprintf('card(S) = %d  (iteration %d)', length(VD.Sk), iMerge))

drawnow 

if params.mergeExport,
  printFigure(gcf,[params.oDir 'merge' num2str(iMerge) '.eps']);
end

if params.movDiag,
  movieHandler(params, 'addframe');
end

