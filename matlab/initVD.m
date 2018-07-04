function VD = initVD(nr, nc, S, VDlim)
% function VD = initVD(nr, nc, S, VDlim)

%
% $Id: initVD.m,v 1.5 2015/04/13 13:54:35 patrick Exp $
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

if 0
  % [VD.x(1,1)  , VD.y(1,1)  ] =  1   1
  % [VD.x(1,nc) , VD.y(1,nc) ] =  nc  1
  % [VD.x(nr,1) , VD.y(nr,1) ] =  1   nr
  % [VD.x(nr,nc), VD.y(nr,nc)] =  nc  nr 
  [VD.x(1,1)  , VD.y(1,1)  ]
  [VD.x(1,nc) , VD.y(1,nc) ]
  [VD.x(nr,1) , VD.y(nr,1) ]
  [VD.x(nr,nc), VD.y(nr,nc)]  

  x=mean(xi);
  y=mean(yi);
  imagesc(xi,yi,sqrt((VD.x-x).^2+(VD.y-y).^2));
  axis xy
  hold on
  plot(x,y,'ko', 'MarkerSize',5)
  hold off
end

% check whether all seeds are in W
inW = isXinW(S, VD.W);
if ~isempty(find(~inW)),
  s = sprintf('Error: seeds outside the image limits\n');
	ii = find(~inW);
	s = [s sprintf('\tk=%3d (%3d,%3d)\n', [ii, S(ii,1:2)]')];
	s = [s sprintf('\n')];
	error(s);
end

% allocate cells for seed's neighbour list
ns = size(S, 1);
% Information about graph data structures can be found at
% http://www.dreamincode.net/forums/topic/282225-data-structures-graph-theory-representing-graphs/
% adjacency list http://en.wikipedia.org/wiki/Adjacency_list
VD.Nk = cell(2,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialise VD with the first seed (k=1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialise time 
VD.k = 1;
% seed's index and coordinates 
VD.Sk = VD.k;
VD.Sx = S(VD.k,1);
VD.Sy = S(VD.k,2);
% all points p in W are in VR(1)
VD.Vk.lambda = VD.k*ones(nr,nc);
% all points have only one nearest seed
VD.Vk.v = zeros(nr,nc);
% and no neighbours
VD.Nk{VD.k} = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Update VD with the second seed (k=2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% update time
VD.k = VD.k + 1;
% seed's index and coordinates
VD.Sk = [VD.Sk; VD.k];
VD.Sx = [VD.Sx; S(VD.k,1)];
VD.Sy = [VD.Sy; S(VD.k,2)];

% compute distance functions
% \mu = d^2(V_1[i,j].\lambda, p), p=(j,i) in W
mu  = (VD.x-VD.Sx(VD.Vk.lambda)).^2+(VD.y-VD.Sy(VD.Vk.lambda)).^2;
% \mu = d^2(s*=2, p), p=(j,i) in W
mus = (VD.x-VD.Sx(VD.k)).^2        +(VD.y-VD.Sy(VD.k)).^2;

% case mu* > mu in Eq. 3.1
% V_2[i,j] = V_1[i,j]
Vk = VD.Vk;
% case mu* < mu in Eq. 3.1
% V_2[i,j] = (s*=2, 0)
ii = find(mus < mu);
Vk.lambda(ii) = VD.k;
Vk.v(ii) = 0;
% case mu* == mu in Eq. 3.1
% V_2[i,j] = (\lambda, 1)
ii = find(mus == mu);
Vk.v(ii) = 1;

% Update Vk 
VD.Vk = Vk;

% Update trivial neighbours
VD.Nk{VD.k-1} = VD.k;
VD.Nk{VD.k} = VD.k-1;

