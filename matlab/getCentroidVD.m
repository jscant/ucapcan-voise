function VD = getCentroidVD(VD, params)
% function VD = getCentroidVD(VD, params)

%
% $Id: getCentroidVD.m,v 1.17 2015/02/13 14:55:15 patrick Exp $
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

% do not attempt to regularise if regMaxIter < 1
if params.regMaxIter < 1,
    return;
else
    regMaxIter = params.regMaxIter;
end

%if params.regAlgo == 2 && exist([voise.root '/share/VOISEtiming.mat'],'file'),
%  timing = load([voise.root '/share/VOISEtiming.mat']);
%end

fprintf(1, '*** Starting regularisation phase\n')

nr = VD.nr;
nc = VD.nc;
ns = length(VD.Sk);

iReg = 1;
stopReg = false;
while ~stopReg,
    
    % compute centre-of-mass of polygons
    Sc = zeros(0, 2);
    Sk = [];
    if params.centroidAlgo == 3
        Sc1 = getCentroidSeedBatch(VD, params.W, VD.Sk);
        for k = 1:length(VD.Sk)
            if isempty(find(Sc1(k, 1) == Sc(:, 1) & Sc1(k, 2) == Sc(:, 2)))
                Sc = [[Sc(:, 1); Sc1(k, 1)], [Sc(:, 2); Sc1(k, 2)]];
                Sk = [Sk; k];
            end
        end
    else
        for k = VD.Sk'
            %	sc1  = getCentroidSeed(VD, params.W, k)
            sc = getCentroidSeed2(VD, params, k);
            %	if sc1(1) ~= sc(1) || sc1(2) ~= sc(2)
            %		disp("Old: %i, %i \t New: %i, %i\n", sc(1), sc(2), sc1(1), sc1(2));
            %	end
            if isempty(find(sc(1) == Sc(:, 1) & sc(2) == Sc(:, 2)))
                %in some cases two centroid seeds could be identical
                % for example here
                % o 1 1
                % 2 x 1
                % 2 2 o
                Sc = [[Sc(:, 1); sc(1)], [Sc(:, 2); sc(2)]];
                Sk = [Sk; k];
            end
        end
        
    end
    %pause
    dist = abs(Sc(:, 1)-VD.Sx(Sk)) + abs(Sc(:, 2)-VD.Sy(Sk));
    dist2 = sqrt((Sc(:, 1) - VD.Sx(Sk)).^2+(Sc(:, 2) - VD.Sy(Sk)).^2);
    fprintf(1, 'Maximum distance seed/centre-of-mass %.1f (%.1f)\n', ...
        max(dist), max(dist2));
    
    % save center-of-mass and indices
    regSc{iReg} = Sc;
    regDist{iReg} = dist;
    regDist2{iReg} = dist2;
    
    if max(dist) > 1 && iReg <= params.regMaxIter,
        fprintf(1, 'Iter %2d Computing regularised Voronoi Diagram for %d seeds\n', ...
            iReg, size(Sc, 1));
        switch params.regAlgo,
            case 0, % incremental
                VD = computeVD(nr, nc, Sc, VD.W);
            case 1, % full
                VD = computeVDFast(nr, nc, Sc, VD.W);
            case 2, % timing based
                ns = size(Sc, 1);
                tf = polyval(timing.ptVDf, ns);
                ti = sum(polyval(timing.ptVDa, [1:ns]));
                fprintf(1, 'Est. time full(%4d:%4d)/inc(%4d:%4d) %6.1f/%6.1f s ', ...
                    1, ns, 1, ns, tf, ti);
                tStart = tic;
                if tf < ti, % full faster than incremental
                    VD = computeVDFast(nr, nc, Sc, VD.W);
                else, % incremental faster full
                    VD = computeVD(nr, nc, Sc, VD.W);
                end
                fprintf(1, '(Used %6.1f s)\n', toc(tStart));
            case 3
                VDTMP = computeVDCpp(nr, nc, Sc, VD.W);
                if (isfield(VD, 'divSHC'))
                    VDTMP.divSHC = VD.divSHC;
                end
                if (isfield(VD, 'divHCThreshold'))
                    VDTMP.divHCThreshold = VD.divHCThreshold;
                end
                if (isfield(VD, 'Smu'))
                    VDTMP.Smu = VD.Smu;
                end
                if (isfield(VD, 'Ssdmu'))
                    VDTMP.Ssdmu = VD.Ssdmu;
                end
                if (isfield(VD, 'addedInRound'))
                    VDTMP.addedInRound = VD.addedInRound;
                end
                VD = VDTMP;
        end
        params = plotCurrentVD(VD, params, iReg);
        iReg = iReg + 1;
        if iReg > params.regMaxIter, stopReg = true;
        end
        %fprintf(1,'Voronoi Diagram computed\n');
    else
        stopReg = true;
    end
end

fprintf(1, '*** Regularisation phase completed.\n')

VD.regSc = regSc;
VD.regDist = regDist;
VD.regDist2 = regDist2;


function params = plotCurrentVD(VD, params, iReg)

if params.centroidAlgo == 3
    VDW = getVDOp(VD, params.W, 1);
else
    VDW = getVDOp2(VD, params.W, @(x) median(x));
end
if 0
    clf
    subplot(111),
    imagesc(VDW),
    axis xy,
    axis equal
    axis off
    set(gca, 'clim', params.Wlim);
    %colorbar
    W = VD.W;
    set(gca, 'xlim', [W.xm, W.xM], 'ylim', [W.ym, W.yM]);
    
    hold on
    [vx, vy] = voronoi(VD.Sx(VD.Sk), VD.Sy(VD.Sk));
    plot(vx, vy, '-k', 'LineWidth', 0.5)
    hold off
    
    colormap(params.colormap);
    
    
    title(sprintf('card(S) = %d  (iteration %d)', length(VD.Sk), iReg))
    
    drawnow
    
    if params.regExport,
        printFigure(gcf, [params.oDir, 'reg', num2str(iReg), '.eps']);
    end
    
    if params.movDiag,
        movieHandler(params, 'addframe');
    end
end
