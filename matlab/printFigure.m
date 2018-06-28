function printFigure(hf,filename)
% function printFigure(hf,filename)

%
% $Id: printFigure.m,v 1.6 2016/10/28 15:12:12 patrick Exp $
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

if exist('exportfig','file') == 2 & ...
   ~strcmp(get(gcf,'XDisplay'),'nodisplay'), 

  %opts = struct('color', 'cmyk', 'boundscode','mcode','LockAxes',0);
  opts = struct('color','cmyk','bounds','tight','LockAxes',1);
  exportfig(hf, filename, opts);

else

  print(hf, '-depsc', filename);

end

