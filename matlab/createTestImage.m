function createTestImage
% function createTestImage

%
% $Id: createTestImage.m,v 1.6 2012/04/16 16:54:27 patrick Exp $
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

% number of rows
nr = 201;
% number of columns
nc = 201;

% x = linspace(-2, 1, nc);
% y = linspace(-1, 2, nr);
% [X,Y] = meshgrid(x,y);
% then 
% [X(1,1)    , Y(1,1)    ] = -2  -1
% [X(1,end)  , Y(1,end)  ] =  1  -1
% [X(end,1)  , Y(end,1)  ] = -2   2
% [X(end,end), Y(end,end)] =  1   2

% # of cols in image corresponds to x coordinate
x     = linspace(-1, 1, nc);
% # of rows in image corresponds to y coordinate
y     = linspace(-1, 1, nr);

% dimensionless pixel unit
pixelUnit = {'',''};

[X,Y] = meshgrid(x, y);

% background level of 10
Z     = 10*zeros(nr,nc);

% large ellipse 
a = 3/4; b = 3/4;
Z(X.^2/a^2+Y.^2/b^2 <= 1) = 20;

% smaller ellipse
a = 1/2; b = 2/3;
Z(X.^2/a^2+Y.^2/b^2 < 1) = 30;

% further smaller ellipse
a = 1/3; b = 1/4;
Z(X.^2/a^2+Y.^2/b^2 < 1) = 20;

% normal RNG seeding 
randn('state', 10);

% add normal noise
Z = Z + randn(nr, nc);

% normalise levels between 1 to 256
Z = fix(255*(Z-min(Z(:)))/(max(Z(:))-min(Z(:))))+1;

imagesc(x,y,Z)
axis xy
colorbar

global voise 
save([voise.root '/share/testImage.mat'], 'x', 'y', 'Z', 'pixelUnit');
