function VD = updateNeighboursListsFromVoronoin(VD,mode,k)
% function VD = updateNeighboursListsFromVoronoin(VD,mode,k)

%
% $Id: updateNeighboursListsFromVoronoin.m,v 1.3 2012/04/16 16:54:28 patrick Exp $
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

switch lower(mode),
  case 'add'
    % Calculate Voronoi Diagram for all seeds, k included
    [V, C] = voronoin([VD.Sx(VD.Sk), VD.Sy(VD.Sk)]);
    % number of seeds
    ns = length(VD.Sk);
		si = VD.Sk(k);
		% neighbourhood of new seed k
	  VD.Nk{si} = [];
		for i = find(C{k} ~= 1), % for all vertices in VR(k) not infinite
			for r = setdiff([1:ns], k), % for all seeds S\k
			  if ~isempty(find(C{r} == C{k}(i))), % common vertex
					ri = VD.Sk(r);
	        VD.Nk{si} = [VD.Nk{si}; setdiff(ri, VD.Nk{si})];
					VD.Nk{ri} = si; % build neighborhood of seed ri
					for j = find(C{r} ~= 1), % for all vertices in VR(ri) not infinite
					  for s = setdiff([1:ns], [k r]), % for all seeds S\{k,ri}
					    if ~isempty(find(C{s} == C{r}(j))),
			          VD.Nk{ri} = [VD.Nk{ri}; setdiff(VD.Sk(s), VD.Nk{ri})];
					    end
						end
					end
				end
			end
		end
	case 'remove'
	  Sk = VD.Sk;
	  % remove k from seed list
	  VD.Sk(find(VD.Sk == k)) = [];
    % Calculate Voronoi Diagram without seed k
    [V, C] = voronoin([VD.Sx(VD.Sk), VD.Sy(VD.Sk)]);
    % number of seeds
    ns = length(VD.Sk);
		for s = VD.Nk{k}', % for all neighbours of VR(k)
		  is = find(VD.Sk == s); % new index
			VD.Nk{s} = []; % build neighborhood of seed s
		  for i = find(C{is} ~= 1), % for all vertices in VR(is) not infinite
				for r = setdiff([1:ns], is), % for all seeds S\is
				  if ~isempty(find(C{r} == C{is}(i))), % common vertex
				     VD.Nk{s} = [VD.Nk{s}; setdiff(VD.Sk(r), VD.Nk{s})];
					end
				end
			end
		end
		VD.Nk{k} = [];
end

return 

% Build the entire VD

% Calculate Voronoi Diagram for current seeds
[V, C] = voronoin([VD.Sx(VD.Sk), VD.Sy(VD.Sk)]);

% number of seeds
ns = length(VD.Sk);

% largest index of seeds
smax = max(VD.Sk);

Nk = cell(smax, 1);
for s = 1:ns, % for each seed s
  %fprintf(1,'seed %d:\n', s);
  for i = 1:length(C{s}), % for all vertices in VR(s)
	  iv = C{s}(i);
		%fprintf(1,' iv=%d, (%f,%f)\n', iv,  V(iv,1:2));
		if iv ~= 1, % not infinite vertex
		  for r = setdiff([1:ns], s), % for all seeds S\s
			  if ~isempty(find(C{r}(:) == iv)),
				  si = VD.Sk(s);
					ri = VD.Sk(r);
				  Nk{si} = [Nk{si}; setdiff(ri, Nk{si})];
				  %Nk{ri} = [Nk{ri}; setdiff(si, Nk{ri})];
				end
			end
		end
	end
end

VD.Nk = [];
VD.Nk = Nk;

% printVD(1, VD);
