function [Wop, Sop] = getFiniteVR(VD, W)
% function [Wop, Sop] = getFiniteVR(VD, W)

%
% $Id: getFiniteVR.m,v 1.3 2012/04/16 16:54:27 patrick Exp $
%
% Copyright (c) 2009-2012 Patrick Guio <patrick.guio@gmail.com>
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


Wop = zeros(size(W));
Sop = zeros(size(VD.Sk));

is = 1;
for s = VD.Sk', % for all seeds
  % find pixels inside the Voronoi region VR(s) or on the boundary
  ii = find(VD.Vk.lambda == s);
	% get vertices list of VR(sk)
	[V,I] = getVRvertices(VD, s);
	if all(isfinite(V)), % finite region
	 Sop(is) = 1;
	 Wop(ii) = Sop(is);
	else
	 Sop(is) = 0;
	 Wop(ii) = Sop(is);
	end
  is = is+1;
end

