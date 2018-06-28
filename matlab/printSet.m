function varargout = printSet(fid, A)
% function varargout = printSet(fid, A)

%
% $Id: printSet.m,v 1.3 2012/04/16 16:54:27 patrick Exp $
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

s = sprintf('{ ');
if ~isempty(A),
  s = [s sprintf('%d ', A)];
end
s = [s sprintf('}')];

if ~isempty(fid), 
  fprintf(fid, '%s', s);
end

if nargout>0,
  varargout(1) = {s};
end
