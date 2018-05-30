function start_VOISE
% function start_VOISE
%
% VOISE (version 1.3.1) startup 
%

% matlab/start_VOISE.m.  Generated from start_VOISE.m.in by configure.
%
% $Id: start_VOISE.m.in,v 1.6 2012/04/16 16:54:28 patrick Exp $
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


global voise

voise.root    = '/home/patrick/research/codes/VOISE';
voise.version = '1.3.1';

fprintf('Setting up VOISE -- version %s\n', voise.version);

addpath([voise.root '/matlab']);
addpath([voise.root '/matlab/limbFit']);
addpath([voise.root '/matlab/imageUtils']);

