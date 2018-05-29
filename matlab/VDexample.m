function VDexample
% function VDexample

%
% $Id: VDexample.m,v 1.4 2012/04/16 16:54:27 patrick Exp $
%
% Copyright (c) 2009-2012 Patrick Guio <patrick.guio@gmail.com>
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

% init seed of Mersenne-Twister RNG
if exist('RandStream','file') == 2,
  RandStream.setDefaultStream(RandStream('mt19937ar','seed',30)));
else
  rand('twister',30);
end

x = round(100*rand(8,1))+1;
y = round(100*rand(8,1))+1;

xm = min(x); xM = max(x);
ym = min(y); yM = max(y);


[vx,vy] = voronoi(x, y);

VD = computeVD(100,100, [x, y]);

hold on
plot(x,y,'xk','MarkerSize',5)
plot(vx,vy,'-k','LineWidth',1);
set(gca,'xlim',[-1 2],'ylim',[-1 2])
for i=1:length(x)
  text(x(i), y(i), num2str(i), 'verticalalignment', 'bottom');
  for j=setdiff(VD.Nk{i}', 1:i),
    plot([x(i), x(j)], [y(i), y(j)], ':k','LineWidth',.5)
  end
end
hold off
axis off
set(gca,'xlim',100*[-.5 1.5],'ylim',100*[-.5 1.5]);
axis equal

%orient tall
%exportfig(gcf,'../agu2008/fig1.eps','color','cmyk');
%opts = struct('color','cmyk','bounds','tight');
%opts = struct('color','cmyk','bounds','tight','linestylemap','bw');
%exportfig(gcf,'../agu2008/fig1.eps',opts);
%savefig('fig1.eps',gcf,'eps','-cmyk','-crop');
