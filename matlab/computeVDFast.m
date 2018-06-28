function VD = computeVDFast(nr, nc, S, VDlim)
% function VD = computeVDFast(nr, nc, S, VDlim)

%
% $Id: computeVDFast.m,v 1.8 2015/02/11 15:50:00 patrick Exp $
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

% update VD structure
VD.nr = nr;
VD.nc = nc;

% set limits of W
VD.W.xm = 1;
VD.W.ym = 1;
VD.W.xM = nc;
VD.W.yM = nr;

% Set limits of VD seeds
VD.S.xm = VDlim.xm;
VD.S.xM = VDlim.xM;
VD.S.ym = VDlim.ym;
VD.S.yM = VDlim.yM;

% initialise grid for image points coordinates
xi = 1:nc;
yi = 1:nr;

% (VD.x(i,j), VD.y(i,j)) contains the coordinates of the point
% with indices (i,j) in array image data
[VD.x, VD.y] = meshgrid(xi,yi);

% check whether all seeds are in W
inW = isXinW(S, VD.W);
if ~isempty(find(~inW)),
  s = sprintf('Error: seeds outside the image limits\n');
  ii = find(~inW);
  s = [s sprintf('\tk=%3d (%3d,%3d)\n', [ii, S(ii,1:2)]')];
  s = [s sprintf('\n')];
  error(s);
end

% seed's index and coordinates 
ns = size(S, 1);
VD.Nk = [];
VD.k = ns;
VD.Sk = [1:ns]';
VD.Sx = S(VD.Sk, 1);
VD.Sy = S(VD.Sk, 2);

% Calculate Voronoi Diagram for current seeds
[V, C] = voronoin([VD.Sx(VD.Sk), VD.Sy(VD.Sk)]);

% allocate cells for seed's neighbour list
Nk = cell(ns, 1);
for s = 1:ns, % for each seed s
  %fprintf(1,'seed %d:\n', s);
	if 0
	fprintf(1,'method 1\n');
	for i = 1:length(C{s}), % for all vertices in VR(s)
	  iv = C{s}(i);
	  if iv ~= 1, % not infinite vertex
	    fprintf(1,' iv=%d, (%f,%f)\n', iv,  V(iv,1:2))
	  end
	end
	fprintf(1,'method 2\n');
	for iv = C{s}(find(C{s}(:) ~= 1)),
	  fprintf(1,' iv=%d, (%f,%f)\n', iv,  V(iv,1:2))
	end
	pause
	end
  for iv = C{s}(find(C{s}(:) ~= 1)), % for all vertices in VR(s) not infinite
    %fprintf(1,' iv=%d, (%f,%f)\n', iv,  V(iv,1:2));
    for r = setdiff([1:ns], s), % for all seeds S\s
      if ~isempty(find(C{r}(:) == iv)),
				Nk{s} = [Nk{s}; setdiff(r, Nk{s})];
        %si = VD.Sk(s);
        %ri = VD.Sk(r);
        %Nk{si} = [Nk{si}; setdiff(ri, Nk{si})];
        %Nk{ri} = [Nk{ri}; setdiff(si, Nk{ri})];
      end
    end
  end
end

VD.Nk = Nk;

% allocate and initialise (lambda,v) structure 
% all points p in W are in VR(1)
VD.Vk.lambda = ones(nr,nc);
% all points have only one nearest seed
VD.Vk.v = zeros(nr,nc);

for s = 2:ns, % for each seed s
  [ii, jj, ij] = getVRclosure(VD, s, VD.Nk{s});

	% compute distance functions
	% \mu = d^2(V_1[i,j].\lambda, p), p=(j,i) in W
	mu  = (VD.x(ij)-VD.Sx(VD.Vk.lambda(ij))).^2+...
	      (VD.y(ij)-VD.Sy(VD.Vk.lambda(ij))).^2;
	% \mu = d^2(s*=2, p), p=(j,i) in W
	mus = (VD.x(ij)-VD.Sx(s)).^2        +(VD.y(ij)-VD.Sy(s)).^2;
	% case mu* > mu in Eq. 3.1
	% V_2[i,j] = V_1[i,j]
	Vk = VD.Vk;
	% case mu* < mu in Eq. 3.1
	% V_2[i,j] = (s*=2, 0)
	iless = find(mus < mu);
	Vk.lambda(ij(iless)) = s;
	Vk.v(ij(iless)) = 0;
	% case mu* == mu in Eq. 3.1
	% V_2[i,j] = (\lambda, 1)
	iequal = find(mus == mu);
	Vk.v(ij(iequal)) = 1;

  % Update Vk 
	VD.Vk = Vk;

end


if 0
fprintf(1,'Voronoi Diagram computed\n')
%pause
end
