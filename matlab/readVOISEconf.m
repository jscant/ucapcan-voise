function params = readVOISEconf(conffile)
% function params = readVOISEconf(conffile)
%
% Read a configuration file that contains
% VOISE parameters and returns a complete
% parameters structure. 
% Note that parameters not specified in the
% file are initialised to their default value.
%
% The syntax is 'key' = 'value' on each line.
%
% For example:
% iNumSeeds = 12
% RNGiseed = 10
% dividePctile = 80
% d2Seeds = 2
% mergePctile = 50
% dmu = 0.2
% thresHoldLength = 0.3
% regMaxIter = 2
% iFile = ../share/input/sampleint.fits
% oDir = ../share/output/sampleint/
% oMatFile = voise
% imageOrigo = [0, 0]
% pixelSize  = [1, 1]
% pixelUnit  = {'pixels', 'pixels'}
%
% 
% Note that lines starting with # are ignored.

%
% $Id: readVOISEconf.m,v 1.5 2012/04/16 16:54:27 patrick Exp $
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

% load default VOISE parameters
params = getDefaultVOISEParams();


% read VOISE configuration file
% all fields initialised by getDefaultVOISEParams 
% can be redefined in the configuration file
% The syntax is
% field = value
fid = fopen(conffile);
C = textscan(fid, '%s%s','Delimiter','=','CommentStyle', '#');
fclose(fid);


% C{1} should contain the string before the delimiter '='
% i.e. the key
key = deblank(C{1});
% C{2} should contain the string after the delimiter '='
% i.e. the value 
val = deblank(C{2});

% replace string value by its numerical argument
% whenever possible, otherwise do not touch the string
for i=1:length(val),
  v = str2num(val{i});
	if ~isempty(v),
	  val{i} = v;
	end
end

for i=1:length(key),
  if isfield(params, key{i}),
    if ischar(val{i}) & val{i}(1)=='{' & val{i}(end)=='}', 
      % special case of cell array requires an eval
      params.(key{i}) = eval(val{i});
    else
      % all other cases i.e. string, scalar and array of scalars
      params.(key{i}) = val{i};
    end
  end
end


