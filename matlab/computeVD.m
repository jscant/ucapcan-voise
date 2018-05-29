function VD = computeVD(nr, nc, S, VDlim)
% function VD = computeVD(nr, nc, S, VDlim)

%
% $Id: computeVD.m,v 1.6 2015/02/11 15:50:00 patrick Exp $
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


VD = initVD(nr, nc, S, VDlim);

ns = size(S, 1);
for k = 3:ns,
  VD = addSeedToVD(VD, S(k,:));
	if 0
  drawVD(VD);
	end
  if 0,
    fprintf(1,'.');
  end
end
if 0
fprintf(1,'\n');
end

if 0
fprintf(1,'Voronoi Diagram computed\n')
%pause
end
