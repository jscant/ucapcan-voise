function S = randomSeeds(nr,nc,ns,VDlim)
% function S = randomSeeds(nr,nc,ns,VDlim)

%
% $Id: randomSeeds.m,v 1.9 2015/02/13 12:31:40 patrick Exp $
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

xm = VDlim.xm;
xM = VDlim.xM;
ym = VDlim.ym;
yM = VDlim.yM;

% initialise array S(ns,2) with uniform distribution over open range
% seed s has coordinates (x,y) = S(s, 1:2) 
%S = round([randraw('uniform', [xm, xM], ns, 1), ...
%           randraw('uniform', [ym, yM], ns, 1)]);
S = round([xm+(xM-xm)*rand(ns, 1), ...
           ym+(yM-ym)*rand(ns, 1)]);

% iterate until all seeds are different
uniqueSeeds=false;
while ~uniqueSeeds,

  nIdentical = 0;
  for k=1:size(S,1),
    ii = find(S(k,1)==S([k+1:end-1],1) & S(k,2)==S([k+1:end-1],2));
    if ~isempty(ii),
      ns = length(ii);
%      S(k+ii,:) = round([randraw('uniform', [xm, xM], ns, 1), ...
%                         randraw('uniform', [ym, yM], ns, 1)]);
      S(k+ii,:) = round([xm+(xM-xm)*rand(ns, 1), ...
                         ym+(yM-ym)*rand(ns, 1)]);
      nIdentical = nIdentical+ns;
    end
  end
  if ~nIdentical,
    uniqueSeeds = true;
  else
    fprintf(1,'nIdentical %d\n', nIdentical);
  end

end
