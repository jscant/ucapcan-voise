function gander94fig23
% function gander94fig23
%
% figure 3.1 and 3.2 from Gander et al., 1994

%
% $Id: gander94figs23.m,v 1.4 2012/04/16 15:45:15 patrick Exp $
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

% eq 3.6 from Gander et al., 1994
x = [1, 2, 5, 7, 9, 6, 3, 8]';
y = [7, 6, 8, 7, 5, 7, 2, 4]';

% rotation pi/4
Q = 1/sqrt(2)*[1, -1; 1 1];

% translation (-6,-6)
T1 = [-6;-6];

% translation (-4,4)
T2 = [-4;4];

x1 = zeros(size(x));
y1 = zeros(size(y));
x2 = zeros(size(x));
y2 = zeros(size(y));
for i=1:length(x),
  xy = (T1+[x(i);y(i)]);
	x1(i) = xy(1);
	y1(i) = xy(2);
  xy = Q*(T2+[x(i);y(i)]);
	x2(i) = xy(1);
	y2(i) = xy(2);
end

plot(x,y,'bo',x1,y1,'g+',x2,y2,'rd')
hold on

% Fit an ellipse using the Bookstein constraint (\lambda_1^2+\lambda_2^2=1)
[zb, ab, bb, alphab] = fitellipse([x,y], 'linear','constraint','bookstein');
plotellipse(zb, ab, bb, alphab, 'b-')
[zb, ab, bb, alphab] = fitellipse([x1,y1], 'linear','constraint','bookstein');
plotellipse(zb, ab, bb, alphab, 'g-')
[zb, ab, bb, alphab] = fitellipse([x2,y2], 'linear','constraint','bookstein');
plotellipse(zb, ab, bb, alphab, 'r-')

% Fit an ellipse using the trace constraint (\lambda_1+\lambda_2=1)
[zb, ab, bb, alphab] = fitellipse([x,y], 'linear','constraint','trace');
plotellipse(zb, ab, bb, alphab, 'b--')
[zb, ab, bb, alphab] = fitellipse([x1,y1], 'linear','constraint','trace');
plotellipse(zb, ab, bb, alphab, 'g--')
[zb, ab, bb, alphab] = fitellipse([x2,y2], 'linear','constraint','trace');
plotellipse(zb, ab, bb, alphab, 'r--')


hold off

