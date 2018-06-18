function S = addSeedsToVR(VD, sk, params)
% function S = addSeedsTOVR(VD, sk, params)

%
% $Id: addSeedsToVR.m,v 1.6 2015/02/11 16:27:12 patrick Exp $
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

% seed coordinates
xs = VD.Sx(sk);
ys = VD.Sy(sk);

% neighbour seeds coordinates
ns = VD.Nk{sk};
xn = VD.Sx(ns);
yn = VD.Sy(ns);

if any(~isfield(params,{'ws','wv'})),
  if 0,
  % weight seed and weight vertices 1/3, 2/3
  ws = 1; wv = 2;
  % weight seed and weight vertices 3/8, 5/8
  % transform an equilateral triangle into four regions of equal area
  ws = 3; wv = 5;
  else
  % weight seed and weight vertices golden number 
  % (sqrt95)-1)/(sqrt(5)+1), 2/(sqrt(5)+1)
  ws = sqrt(5)-1; wv = 2;
  end
else
  ws = params.ws;
  wv = params.wv;
end
% sum of weights
wt = ws+wv;

% get vertices list of VR(sk)
[V,I] = getVRvertices(VD, sk);
Sx = []; Sy = [];
for i = 1:size(V,1),
	x = round((ws*xs+wv*V(i,1))/wt);
	y = round((ws*ys+wv*V(i,2))/wt);
	% list all immediate neighbour seeds (sk, N(sk), S added)
	Sxs = [xs; xn(:); Sx(:)]; 
	Sys = [ys; yn(:); Sy(:)]; 
	if isXinW([x,y], VD.S) && ...  
	   all((Sxs-x).^2+(Sys-y).^2 > params.d2Seeds*ones(size(Sxs))),
	    Sx = [Sx; x];
	    Sy = [Sy; y];
	end
end
S = [Sx(:), Sy(:)];

if 0
    %subplot(212)
    clf

    plot(xs,ys,'ok', 'MarkerSize',8)
    text(xs,ys, num2str(sk), 'verticalalignment', 'bottom');
    W = VD.W;
    set(gca,'xlim',[W.xm W.xM], 'ylim', [W.ym W.yM]);
    hold on
    for i=1:length(ns),
      plot(xn(i),yn(i),'xk', 'MarkerSize',8)
        text(xn(i),yn(i), ['n' num2str(ns(i))], 'verticalalignment', 'bottom');
    end
    for i=1:size(S,1)
      plot(S(i,1),S(i,2),'xk', 'MarkerSize',8)
        text(S(i,1),S(i,2), ['i' num2str(i)], 'verticalalignment', 'bottom');
    end
    for i=1:size(V,1)
      plot(V(i,1),V(i,2),'xk', 'MarkerSize',8)
        text(V(i,1),V(i,2), ['v' num2str(i)], 'verticalalignment', 'bottom');
    end
    [vx,vy]=voronoi(VD.Sx(VD.Sk), VD.Sy(VD.Sk));
    plot(vx,vy,'-k','LineWidth',1)
    hold off
    %pause

    for i=1:size(S,1),
      if ~isempty(find(S(i,1)==VD.Sx & S(i,2)==VD.Sy)),
          sk = find(S(i,1)==VD.Sx & S(i,2)==VD.Sy);
            s = sprintf('Error: seed i%d=(%d,%d) already in S(%d)=(%d,%d)', ...
                    i, S(i,1),S(i,2), sk, VD.Sx(sk), VD.Sy(sk));
          fprintf(1,'%s\n', s);
            V,I
            pause
        end
    end

end
