function varargout = printVD(fid, VD)
% function varargout = printVD(fid, VD)

%
% $Id: printVD.m,v 1.5 2012/04/16 16:54:27 patrick Exp $
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

% current time
k = VD.k;

s = sprintf('\n');

s1 = sprintf('*** Voronoi Diagram Neighbours k = %d ***', k);
s2 = char('*'*ones(length(s1),1));
s3 = sprintf('Seed\tNeighbours');

s = [s sprintf('%s\n%s\n', s1, s3)];

%for i = VD.Sk', % for all seeds at current time 
for i = 1:length(VD.Nk), % for all seeds that ever been registered
  s = [s sprintf('N%d(%d)\t', k, i)];
	s1 = printSet([], VD.Nk{i}); s = [s s1];
  s = [s sprintf('\n')];
end

%s = [s sprintf('%s\n\n',s2)];

if ~isempty(fid),
	fprintf(fid, '%s', s);
end

if nargout>0,
	varargout(1) = s;
end


