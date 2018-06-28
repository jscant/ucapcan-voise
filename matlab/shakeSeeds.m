function S = shakeSeeds(S,nr,nc,VDlim,radfluct)
% function S = shakeSeeds(S,nr,nc,VDlim,radfluct)

%
% $Id: shakeSeeds.m,v 1.1 2015/02/13 12:27:34 patrick Exp $
%
% Copyright (c) 2015 Patrick Guio <patrick.guio@gmail.com>
% All Rights Reserved.
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 3 of the License, or (at your
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

Sc = S;

if ~exist('radfluct','var') || isempty(radfluct),
	return;
end

nS = size(S,1);

rho = radfluct*(rand(nS,1)+eps);
the = 2*pi*rand(nS,1);

R = round([rho.*cos(the),rho.*sin(the)]);

%r = round([radfluct*(2*rand(nS,1)-1), radfluct*(2*rand(nS,1)-1)]);

for i=1:nS,
  s = Sc(i,:) + R(i,:);
  while s(1)<1 || s(1)>nc || s(2)<1 || s(2)>nr, % out of image
	  r = radfluct*(rand(1)+eps);
		t = 2*pi*rand(1);
		r = round([r.*cos(t),r.*sin(t)]);
	  s = Sc(i,:) + r;
	end
	S(i,:) = s;
end

% iterate until all seeds are different
uniqueSeeds=false;
while ~uniqueSeeds,

  nIdentical = 0;
  for k=1:nS,
    ii = find(S(k,1)==S([k+1:end-1],1) & S(k,2)==S([k+1:end-1],2));
    if ~isempty(ii),
      ns = length(ii);
      rho = radfluct*(rand(ns,1)+eps);
      the = 2*pi*rand(ns,1);
			R = round([rho.*cos(the),rho.*sin(the)]);
      for i=1:ns,
        Sk = zeros(ns,2);
        s = Sc(i,:) + R(i,:);
        while s(1)<1 || s(1)>nc || s(2)<1 || s(2)>nr, % out of image
          r = radfluct*(rand(1)+eps);
          t = 2*pi*rand(1);
          r = round([r.*cos(t),r.*sin(t)]);
          s = Sc(i,:) + r;
        end
	      Sk(i,:) = s;
      end
      S(k+ii,:) = Sk;
			nIdentical = nIdentical+ns;
		end
	end
	if ~nIdentical,
	  uniqueSeeds = true;
	else
	  fprintf(1,'nIdentical %d\n', nIdentical);
	end

end
  
