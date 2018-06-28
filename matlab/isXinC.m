function inC = isXinC(X, rsu,  s, A, VD)
% function inC = isXinC(X, rsu, s, A, VD)
% 
% Check whether the points X(r,s,u) (X has size [n, 2]) equidistant 
% from seeds with indices r,s,u (rsu has size [n, 3]) are in set C(s, A)
% as defined in Eq. 2.2.  A is a list of indices of seeds
% 
% Note that C(s, S\{s}) is the closure of the Voronoi region associate
% to seed s
%

% Algorithm described in 
% Discrete Voronoi Diagrams and the SKIZ Operator: A Dynamic Algorithm
% R. E. Sequeira and F. J. Preteux
% IEEE Transactions on pattern analysis and machine intelligence
% Vol. 18, No 10, October 1997

%
% $Id: isXinC.m,v 1.4 2015/02/11 16:12:10 patrick Exp $
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

if ~isempty(rsu), % if rsu empty don't look for cocircularity
  % Look for cocircular points
	inC = cocircular(X, rsu, VD);
else
  % assume all points X are in C(s, A)
	inC = true(size(X,1), 1);
end

for i = find(inC)', % for all equidistant points X cocircular-filtered 

  x = X(i,1);
	y = X(i,2);

	if ~isempty(rsu) && s~= rsu(i,2),
	  str = sprintf('Error: s=%d expected in C(s,A), found s=%d', rsu(i,2), s);
		%error(str);
		fprintf(1,'%s\n',str); pause
	end

  if ~isfinite(x) || ~isfinite(y), % colinear seeds r, s, u
	  % NEEDS more work!!!
		% coordinates of seed r
		r1 = VD.Sx(rsu(i,1)); r2 = VD.Sy(rsu(i,1));
		% coordinates of seed s
		s1 = VD.Sx(rsu(i,2)); s2 = VD.Sy(rsu(i,2));
		% coordinates of seed u
		u1 = VD.Sx(rsu(i,3)); u2 = VD.Sy(rsu(i,3));
		% find out whether r in H(s,u)
    if (r1-s1)^2+(r2-s2)^2 > (r1-u1)^2+(r2-u2)^2, % r in H(u,s)
		  fprintf(1,'%d  in H(%d,%d)\n', rsu(i,:));
		  inC(i) = false; % true;
		else
		  fprintf(1,'%d ~in H(%d,%d)\n', rsu(i,:));
		  inC(i) = false;
    end
	else, % no collinear seeds
    for r = A(:)', % for all seed r in A
      % coordinates of seed s 
      s1 = VD.Sx(s); s2 = VD.Sy(s);
      % coordinates of seed r 
      r1 = VD.Sx(r); r2 = VD.Sy(r);

      % X(x,y) / a*x + b*y = c
		  % are points of bisector of (R,S). i.e. such that
		  % \vec{RS}.\vec{OX} = |\vec{OS}|^2-|\vec{OR}|^2/2
		  %
      % X(x,y) / a*x + b*y > c
		  % are points such that d(X,R)<d(X,S), i.e.
		  % (\vec{OS}-\vec{OR}).\vec{OX} > |\vec{OS}|^2-|\vec{OR}|^2/2

      % \vec{OS}-\vec{OR}
      a = s1-r1; b = s2-r2;
		  % |\vec{OS}|^2-|\vec{OR}|^2/2 
      c = (s1^2+s2^2-r1^2-r2^2)/2;

      %   a*x+b*y>=c  \sim   d(X,S) <= d(X,R)
      % ~(a*x+b*y>=c) \sim ~(d(X,S) <= d(X,R))
      %   a*x+b*y< c  \sim   d(X,S) >  d(X,R)
      if a*x+b*y-c<0.0 && abs(a*x+b*y-c)>1e4*eps, % check *really* negative
		    % d(X,R)<d(X,S) implies X not in C(s,A)
		    inC(i) = inC(i) & false;
				break;
				if 0
          % d(X,S) and d(X,R)
		      dXS = sqrt((x-s1)^2+(y-s2)^2); dXR = sqrt((x-r1)^2+(y-r2)^2);
					fprintf(1,'ax+by=%5e <  c=%5e: diff=%5e\n',a*x+b*y,c,a*x+b*y-c);
				  fprintf(1,'d(X,S=%d)=%5e  > d(X,R=%d)=%5e: diff=%5e\n', ...
				    s,dXS,r,dXR,dXS-dXR);
				end
			else
			  if 0
          % d(X,S) and d(X,R)
		      dXS = sqrt((x-s1)^2+(y-s2)^2); dXR = sqrt((x-r1)^2+(y-r2)^2);
					fprintf(1,'ax+by=%5e >= c=%5e: diff=%5e\n',a*x+b*y,c,a*x+b*y-c);
				  fprintf(1,'d(X,R=%d)=%5e <= d(X,S=%d)=%5e: diff=%5e\n', ...
				    s,dXS,r,dXR,dXS-dXR);
				end
      end
      if 0
			plot(s1,s2,r1,r2,x,y,'xk','MarkerSize', 5);
			text(s1,s2,num2str(s),'verticalalignment','bottom');
			text(r1,r2,num2str(r),'verticalalignment','bottom');
			text(x,y,'X','verticalalignment','bottom');
			W = VD.W;
			set(gca,'xlim',[W.xm W.xM],'ylim',[W.ym W.yM]);
			pause
			end
    end % loop over seed r in A


	end % collinear/noncollinear seeds
	
	if ~isempty(rsu),
	fprintf(1,'(%10f,%10f) = X(%2d,%2d,%2d) ', X(i,:), rsu(i,:));
	if inC(i), fprintf(1,' in C(%d, X)\n',s);
	else, fprintf(1,'~in C(%d, X)\n',s); end
	end

end % end loop over equidistant points X

return
% Look for cocircular points
ic = cocircular(X, inC);
if ~isempty(ic)
  p = rsu(ic(1),1); p1 = VD.Sx(p); p2 = VD.Sy(p);
	m = rsu(ic(1),2); m1 = VD.Sx(m); m2 = VD.Sy(m);
  alpha = atan2(m2-p2,m1-p1);
	fprintf(1,'arc(%d,%d) = %5f rad\n', p, m, alpha(end));
  for i=ic(:)',
	  m = rsu(i,3); m1 = VD.Sx(m); m2 = VD.Sy(m);
	  alpha = [alpha; atan2(m2-p2,m1-p1)];
	  fprintf(1,'arc(%d,%d) = %5f rad\n', p, m, alpha(end));
	end
	[salpha, i] = sort(alpha);
	iin = i(2:end-1);
	for i=iin(:)',
	  inC(i) = false;
	fprintf(1,'(%10f,%10f) = X(%2d,%2d,%2d) ', X(i,:), rsu(i,:));
	fprintf(1,'~in C(%d, X)\n',s);
	end
end

function inC = cocircular(X, rsu, VD)

% assume all points X are not cocircular
inC = true(size(X,1), 1);

% Do not consider case when less than three equidistant points
if size(X,1)<3,
  return;
end

% list all X points
fprintf(1,'Looking for cocircular points amongst\n');
for i=1:size(X,1),
  fprintf(1,'\t(%10f,%10f) = X(%2d,%2d,%2d)\n', X(i,:), rsu(i,:));
end

lc = [];
for i=1:size(X,1)-1, % for all X except last one
  %fprintf(1,'Looking for (%10f,%10f) = X(%2d,%2d,%2d)\n', X(i,:), rsu(i,:));
	j = setdiff(1:size(X,1), 1:i); % remove points already checked
	% seeds are cocircular if the equidistant points of two triplets
	% amongst those seeds are the same point
  ii = find(abs(X(i,1)-X(j,1))<eps*abs(X(i,1)) & ...  
	          abs(X(i,2)-X(j,2))<eps*abs(X(i,2)));
  if ~isempty(ii), % add cocircular points of X with index i
		  lc{i} = [i; i+ii(:)];
  end
end

if ~isempty(lc),
	for ilc=1:length(lc),
	  if ~isempty(lc{ilc}), % for all points refered as cocircular
      fprintf(1,'Cocircular points X = '); 
	    printSet(1, lc{ilc});
	    fprintf(1,'\n');

      % p is the index corresponding to X(r=p,s,u)
      p = rsu(lc{ilc}(1),1); p1 = VD.Sx(p); p2 = VD.Sy(p);
      % m is the index corresponding to X(r,s=m,u)
      m = rsu(lc{ilc}(1),2); m1 = VD.Sx(m); m2 = VD.Sy(m);
		  alpha = atan2(m2-p2,m1-p1);
			fprintf(1,'arc(%d,%d) = %5f rad\n', p, m, alpha(end));
      for i=lc{ilc}(:)',
	      m = rsu(i,3); m1 = VD.Sx(m); m2 = VD.Sy(m);
	      alpha = [alpha; atan2(m2-p2,m1-p1)];
	      fprintf(1,'arc(%d,%d) = %5f rad\n', p, m, alpha(end));
	    end
	    [sa, is] = sort(alpha);
	    for i=is(2:end-1)',
			  if i>1, i = i-1; end
				i = lc{ilc}(i);
			  inC(i) = false;
	      fprintf(1,'(%10f,%10f) = X(%2d,%2d,%2d) removed\n', X(i,:), rsu(i,:));
	    end
		end
	end
end



function h = H(p1,p2,p3,p4)
% From Eq. 2.4.10 page 80 in 
% Spatial tessellations: Concepts and applications of Voronoi diagrams by
% A. Okabe, B. Boots K. Sugihara and S.N. Chiu


% H(p1,p2,p3,p4) = 0 : p1,p2,p3,p4 cocircular
% H(p1,p2,p3,p4) > 0 : p4 outside circle defined by p1,p2,p3 
%                      (or any permutation)
% H(p1,p2,p3,p4) < 0 : p4 inside circle defined by p1,p2,p3
%                      (or any permutation)

h = det( ...
        [1, p1(1), p1(2), p1(1)^2+p1(2)^2; ...
         1, p2(1), p2(2), p2(1)^2+p2(2)^2; ...
         1, p3(1), p3(2), p3(1)^2+p3(2)^2; ...
         1, p4(1), p4(2), p4(1)^2+p4(2)^2] ...
       );



