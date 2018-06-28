function h = H(p1,p2,p3,p4)
% function h = H(p1,p2,p3,p4)

%
% $Id: H.m,v 1.4 2012/04/16 16:54:27 patrick Exp $
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

% See Eq. 2.4.10 page 80 in Spatial Tesselation and Applications 
% of Voronoi Diagrams, Okabe, 2000
%
% h == 0 means p1,p2,p3 and p4 are cocircular points
%
% h/6 represents the signed volume of the tetrahedron 
% with vertices p1,p2,p3 and p4
h = det( ...
        [1, p1(1), p1(2), p1(1)^2+p1(2)^2; ...
         1, p2(1), p2(2), p2(1)^2+p2(2)^2; ...
         1, p3(1), p3(2), p3(1)^2+p3(2)^2; ...
         1, p4(1), p4(2), p4(1)^2+p4(2)^2] ...
       );



