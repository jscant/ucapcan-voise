% 
% start up file for VOISE
%

%
% $Id: startup.m,v 1.3 2012/04/16 15:45:15 patrick Exp $
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


set(0,'DefaultAxesFontName','times');
set(0,'DefaultAxesFontWeight','normal');
set(0,'DefaultAxesFontSize',14);

set(0,'DefaultAxesTickDir','in');
set(0,'DefaultAxesXGrid','on');
set(0,'DefaultAxesYGrid','on');
set(0,'DefaultAxesZGrid','on');

set(0,'DefaultTextFontName','times');
set(0,'DefaultTextFontWeight','normal');
set(0,'DefaultTextFontSize',16);

set(0,'DefaultLineMarkersize',2);
set(0,'DefaultLineLineWidth',.2);

set(0,'DefaultSurfaceLineWidth',.65);

clear all
close all

addpath ..
start_VOISE
rmpath ..

