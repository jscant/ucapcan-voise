function varargout = printSeeds(fid, VD, params)
% function varargout = printSeeds(fid, VD, params)

%
% $Id: printSeeds.m,v 1.6 2012/04/16 16:54:27 patrick Exp $
%
% Copyright (c) 2010-2012 Patrick Guio <patrick.guio@gmail.com>
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

% compute scale length in pixels unit
%[WLS,SLS] = getVDOp(VD, params.W, @(x) sqrt(length(x)));
[WLS,SLS] = getVDOp(VD, params.W, 4);


% compute median intensity
%[WDM,SIM] = getVDOp(VD, params.W, @(x) median(x));
[WDM,SIM] = getVDOp(VD, params.W, 1);

s = sprintf('\n');

s1 = sprintf('***             Voronoi Diagram k = %4d         ***', k);
s2 = sprintf('*** index      sx      sy         ls         mi  ***');
s3 = char('*'*ones(length(s1),1));

s = [s sprintf('%s\n%s\n%s\n', s3, s1, s2, s3)];

j = 1;
for i = VD.Sk', % for all seeds at current time
  s = [s sprintf('%9d %7d %7d %10.3g %10.3g\n', ...
                 i, VD.Sx(i), VD.Sy(i), SLS(j), SIM(j))];
	j = j +1;
end

s = [s sprintf('%s\n\n',s3)];

if ~isempty(fid),
	fprintf(fid, '%s', s);
end

if nargout>0,
	varargout(1) = s;
end


