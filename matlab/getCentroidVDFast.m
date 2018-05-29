function CVD = getCentroidVDFast(VD, params)
% function CVD = getCentroidVDFast(VD, params)

%
% $Id: getCentroidVDFast.m,v 1.6 2015/02/11 16:14:50 patrick Exp $
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

if params.regMaxIter < 1,
  CVD = [];
  return;
end

fprintf(1,'Computing Centroid Voronoi Diagram\n')

nr = VD.nr;
nc = VD.nc;
ns = length(VD.Sk);

% get centroid seeds
Sc = zeros(0,2);
Sk = [];
for k = VD.Sk',
  sc  = getCentroidSeed(VD, params, k);
	if isempty(find(sc(1) == Sc(:,1) & sc(2) == Sc(:,2)))
	  % in some cases two centroid seeds could be identical
		% for example here
		% o 1 1 
    % 2 x 1
		% 2 2 o
    Sc = [[Sc(:,1); sc(1)],[Sc(:,2); sc(2)]];
		Sk = [Sk; k];
	end
end
%pause
% compute centroid Voronoi Diagram 
CVD = computeVDFast(nr, nc, Sc, VD.W);

iter = 1;
while max(abs(CVD.Sx(CVD.Sk)-VD.Sx(Sk)) + ...
          abs(CVD.Sy(CVD.Sk)-VD.Sy(Sk))) > 1e-2 && iter<params.regMaxIter, 
  % copy CVD to old VD
  VD = CVD;
  Sc = zeros(0,2);
	Sk = [];
  for k = VD.Sk',
    sc  = getCentroidSeed(VD, params, k);
		if isempty(find(sc(1) == Sc(:,1) & sc(2) == Sc(:,2)))
	    % in some cases two centroid seeds could be identical
      Sc = [[Sc(:,1); sc(1)],[Sc(:,2); sc(2)]];
			Sk = [Sk; k];
		end
  end
  %pause
  CVD = computeVDFast(nr, nc, Sc, VD.W);
	iter = iter + 1;
end
fprintf(1,'Centroid Voronoi Diagram computed\n')

