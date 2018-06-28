function inW = isXinW(X, W)
% function inW = isXinW(X, W)
% 
% Check whether the n points X(n, 2) are within the image limits
% 

% Algorithm described in 
% Discrete Voronoi Diagrams and the SKIZ Operator: A Dynamic Algorithm
% R. E. Sequeira and F. J. Preteux
% IEEE Transactions on pattern analysis and machine intelligence
% Vol. 18, No 10, October 1997

%
% $Id: isXinW.m,v 1.4 2015/02/11 16:10:08 patrick Exp $
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

% assume all points X are within the image limits
% and initialise return flags to true
inW = true(size(X,1), 1);

for i = 1:size(X,1),

  x = X(i,1);
	y = X(i,2);

  if ~isfinite(x) || ~isfinite(y), % point at infinity 
	  inW(i) = false;
	elseif x<W.xm || x>W.xM || y<W.ym || y>W.yM, % point out of range
	  inW(i) = false;
	end

end

