function S = getCentroidSeed2(VD, params, k)
% function S = getCentroidSeed(VD, params, k)

%
% $Id: getCentroidSeed.m,v 1.11 2012/04/16 16:54:27 patrick Exp $
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

% find out closure of Voronoi Region associated to seed k
[ii, jj, ij] = getVRclosure(VD, k, VD.Nk{k});

x = jj;
y = ii;

if 0,
    % uniform weight
    w = ones(size(params.W(ij)));
    S = round([mean(x), mean(y)]);
else, 
    % image intensity weight
    % Be careful when weight < 0 !
    w = abs(params.W(ij));
    if ~any(w), % all weight equal zero
        w = ones(size(params.W(ij)));
        S = round([mean(x), mean(y)]);
    else
        S = round([sum(x.*w), sum(y.*w)]/sum(w));
    end
end

if 0,% any(S<1) | any(S>size(params.W')),
    fprintf(1, 'Seed %3d = (%3d, %3d), Centroid Seed = (%3d, %3d)\n', ...
        k, VD.Sx(k), VD.Sy(k), S(1), S(2));
    imagesc(params.W)
    axis xy
    hold on
    %scatter(x,y,1,-Inf*0.5*w);
    plot(x,y,'w.','markersize',5);
    plot(VD.Sx(k),VD.Sy(k),'kx',S(1),S(2),'ko','markersize',5)
    hold off
    pause
end

