%
% webVOISEdemo3: script for demo1 with config webVOISEdemo3.dat
%

% $Id: webVOISEdemo3.m,v 1.1 2018/05/30 16:44:59 patrick Exp $
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

colormap(jet) 

%profile on
%compileMEX;
webVOISE('../share/VOISEdemo3.dat');

%profile off
%profsave(profile('info'),'profile_results')


%quit
