function dr = jacLimbModel2(t,r,p,dp,func)
% function dr = jacLimbModel2(t,r,p,dp,func)

%
% $Id: jacLimbModel.m,v 1.1 2009/10/16 13:55:35 patrick Exp $
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

if length(p) == 3,

  dr = dcircle2(t,r,p,dp,func);

elseif length(p) == 5,

  dr = dellipse2(t,r,p,dp,func);

end

