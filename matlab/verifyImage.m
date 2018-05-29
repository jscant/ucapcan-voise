function verifyImage(filename)
% function verifyImage(filename)
% 
% Wrapper to loadImage to check whether filename 
% contains an image that can be read in VOISE.
%
% If no argument is provided further help is provided 
% about the data formats supported.

%
% $Id: verifyImage.m,v 1.9 2012/04/16 16:54:28 patrick Exp $
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

% disable warning about using handle graphics with -nojvm
warning('off','MATLAB:HandleGraphics:noJVM');

% diable warning "Unable to determine format of the card value."
%warning('off','MATLAB:fitsinfo:unknownFormat');

% try to load the file as an image
try
  % load default VOISE parameters
  params = getDefaultVOISEParams;
	if exist('filename','var') & ~isempty(filename),
    % assign iFile
    params.iFile = filename;
    % load Image
    params = loadImage(params);
	else
	  help('verifyImage');
		help('loadImage'); 
	end
catch me
  disp(['Problem when verifying image file ' filename '.']);
  rethrow(me);
end

return
