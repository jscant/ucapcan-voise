function A = VD2AdjacencyMatrix(VD)
% function A = VD2AdjacencyMatrix(VD)

%
% $Id: VD2AdjacencyMatrix.m,v 1.1 2015/04/16 14:17:44 patrick Exp $
%
% Copyright (c) 2015 Patrick Guio <patrick.guio@gmail.com>
% All Rights Reserved.
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 3 of the License, or (at your
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

% Adjacency
A = zeros(length(VD.Nk));

for i = 1:length(VD.Nk), % for all seeds that ever been registered
  for n = 1:length(VD.Nk{i}),
	  j = VD.Nk{i}(n);
		% Adjacency
		A(i,j) = 1;
	end
end
