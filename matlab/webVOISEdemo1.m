%
% webVOISEdemo1: script for demo1 with config webVOISEdemo1.dat
%

% $Id: webVOISEdemo1.m,v 1.5 2015/01/23 10:25:05 patrick Exp $
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
clc; clear all; clf;
%compileMEX;
%profile on;
webVOISE('../share/VOISEdemo1.dat');

%profsave(profile('info'),'profile_results')
%quit
