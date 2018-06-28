function [ii,jj,ij] = getVRclosure(VD, s, A)
% function [ii,jj,ij] = getVRclosure(VD, s, A)
% 
% Get p(i,j) in W that lie in C(s, N_k(s)), i.e. 
% in the closure of the Voronoi region associated to seed s
% 
% C(s, S\{s}) is the closure of the Voronoi region associate to seed s


% Algorithm described in 
% Discrete Voronoi Diagrams and the SKIZ Operator: A Dynamic Algorithm
% R. E. Sequeira and F. J. Preteux
% IEEE Transactions on pattern analysis and machine intelligence
% Vol. 18, No 10, October 1997

%
% $Id: getVRclosure.m,v 1.3 2012/04/16 16:54:27 patrick Exp $
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

% indices in W of seed s
si = VD.Sy(s);
sj = VD.Sx(s);

% get interval for s
[ii, jj] = getColumns(s, si, A, VD);

for i = si+1:VD.nr, % for each row in W above seed s 
  [is, js] = getColumns(s, i, A, VD);
	if ~isempty(ii),
	  ii = [ii; is];
	  jj = [jj; js];
	else
	  break
	end
end

for i = si-1:-1:1, % for each row in W below seed s 
  [is, js] = getColumns(s, i, A, VD);
	if ~isempty(ii),
	  ii = [ii; is];
	  jj = [jj; js];
	else
	  break
	end
end

ij = sub2ind([VD.nr, VD.nc], ii, jj);

function [ii, jj] = getColumns(s, i, A, VD)

% coordinates of seed s
s1 = VD.Sx(s);
s2 = VD.Sy(s);

jm = 1;
jM = VD.nc;
for r = A(:)', % for all seed r in N_k(s)

  % coordinates of seed r 
  r1 = VD.Sx(r);
  r2 = VD.Sy(r);

  % X(x,y) / a*x + b*y = c
  % are points of bisector of (R,S). i.e. such that
  % \vec{RS}.\vec{OX} = |\vec{OS}|^2-|\vec{OR}|^2/2
  %
  % X(x,y) / a*x + b*y > c
  % are points such that d(X,R)<d(X,S), i.e.
  % (\vec{OS}-\vec{OR}).\vec{OX} > |\vec{OS}|^2-|\vec{OR}|^2/2

  % \vec{OS}-\vec{OR}
  a = s1-r1;
  b = s2-r2;
  % |\vec{OS}|^2-|\vec{OR}|^2/2 
  c = (s1^2+s2^2-r1^2-r2^2)/2;

  if a > 0.0, % jm = (c-b*i)/a = f1(i) <= j
    jm = max(jm, ceil((c-b*i)/a));
	elseif a < 0.0, % j <= f2(i) = (c-b*i)/a = jM
	  jM = min(jM, floor((c-b*i)/a));
	elseif a == 0.0,
	  if b*i >= c, % b*i >= c then all j in [1, nc]
	    jm = max(jm, 1);
		  jM = min(jM, VD.nc);
	  else, % b*i < c then none j
	    jm = [];
		  jM = [];
	  end
	end
	%[jm, jM]

end

%[jm, jM]
%pause
js =  [max(jm,1):min(jM,VD.nc)]';
jj = js;
ii = i*ones(length(js),1);
