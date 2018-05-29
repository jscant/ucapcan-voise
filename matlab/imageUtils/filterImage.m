function Y = filterImage(X,winSize,op)
% function Y = filterImage(X,winSize,op)
% 
%  X       : image
%  winSize : size of (pixel-centred) kernel (should be odd in both dims)
%  op      : either a function or a discrete kernel 
%  varargin: optional arguments for function op
% 
% Examples of kernels 
%
%                3x3 Laplacian
%                -------------
%
%                [0,  1,  0; ...
%                 1, -4,  1; ...
%                 0,  1,  0];
%
%                [1/sqrt(2),  1,  1/sqrt(2); ...
%                 1        , -8,          1; ...
%                 1/sqrt(2),  1,  1/sqrt(2)];


%
% $Id: filterImage.m,v 1.5 2018/03/08 15:40:07 patrick Exp $
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

% get size of image X 
[nr,nc] = size(X);

% allocate filtered image Y
Y = zeros(nr,nc);

% check for sliding window size to be odd
wnr = winSize(1);
wnc = winSize(2);
if ~mod(wnr,2) | ~mod(wnc,2)
  error('Sliding window must have odd size in both directions.');
end

% check type of op
switch exist('op'),
  case 0, % op does not exist
		[op, msg] = fcnchk(@median);
  case 1, % op is a variable
    if isa(op,'char') | isa(op,'function_handle'),
		  [op, msg] = fcnchk(op);
		elseif all(size(op)==winSize),
			kernel = op;
		  op = [];
		else
		  error('matrix op is not of size winSize')
		end
	case {2,3,5}, % op is a m-file, mex-file or built-in function
    [op, msg] = fcnchk(op);
	otherwise,
	  error('op is not of recognised type')
end


% row and column relative indices to centre point 
ir = fix(-wnr/2):fix(wnr/2);
ic = fix(-wnc/2):fix(wnc/2);

if ~isempty(op), % filter with a given function

  switch func2str(op),

	  case {'mean','median'},

      for i=1:nr,
        for j=1:nc,
	        % calculate indices for window at (i,j)
	        I = ir+i;  
		      J = ic+j;
			    % Xwin contains the image points within window at (i,j)
		      Xwin = X(I(I>=1 & I<=nr), J(J>=1 & J<=nc));
		      % compute filtered value at (i,j) 
		      Y(i,j) = op(Xwin(:));
	      end
      end

		case {'wiener2'},

		  Y = wiener2(X,winSize);

		case {'medfilt2'},

		  Y = medfilt2(X,winSize,'symmetric');

    otherwise,

      [Ir,Ic] = meshgrid(ir, ic);
      for i=1:nr,
        for j=1:nc,
	        % calculate indices for window at (i,j)
	        I = ir+i;  
		      J = ic+j;
			    % Xwin contains the image points within window at (i,j)
		      Xwin = X(I(I>=1 & I<=nr), J(J>=1 & J<=nc));
			    Iwin = Ir(I>=1 & I<=nr, J>=1 & J<=nc);
			    Jwin = Ic(I>=1 & I<=nr, J>=1 & J<=nc);
		      % compute filtered value at (i,j) 
		      Y(i,j) = op(Xwin,winSize,Iwin,Jwin);
	      end
      end

	  end

else, % filter with a discrete kernel (matrix)

  for i=1:nr,
    for j=1:nc,
	    % calculate indices for window at (i,j)
	    I = ir+i;  
		  J = ic+j;
		  % Xwin contains the image points within window at (i,j)
		  Xwin = zeros(winSize);
		  Xwin(I>=1 & I<=nr,J>=1 & J<=nc) = X(I(I>=1 & I<=nr),J(J>=1 & J<=nc));
		  % compute filtered value at (i,j) 
		  Y(i,j) = sum(sum(kernel.*Xwin));
	  end
  end

end
