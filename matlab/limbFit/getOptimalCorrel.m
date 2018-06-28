function [i,j] = getOptimalCorrel(A,B)
% function [i,j] = getOptimalCorrel(A,B)

%
% $Id: getOptimalCorrel.m,v 1.1 2013/03/22 14:38:40 patrick Exp $
%
% Copyright (c) 2013 Patrick Guio <patrick.guio@gmail.com>
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

[nra, nca] = size(A);
[nrb, ncb] = size(B);

% nrc = 2*max(nra,nrb)-1;
% ncc = 2*max(nca,ncb)-1;

ia = 1:nra;
ja = 1:nca;

ib = 1:nrb;
jb = 1:ncb;

ic = -max(nra,nrb):max(nra,nrb);
jc = -max(nca,ncb):max(nca,ncb);

C = xcorr2(A,B);

[max_c, imax] = max(C(:));
[i,j] = ind2sub(size(C),imax);

i = ic(i);
j = jc(j);

fprintf(1,'optimal correl @ x = %d, y = %d\n', j, i)

if 0,

subplot(311), imagesc(ja,ia,A); 
axis xy, axis equal, axis tight
subplot(312), imagesc(jb+j,ib+i,B); 
axis xy, axis equal, axis tight
subplot(313), imagesc(ic,jc,C); 
axis xy, axis equal, axis tight

else

subplot(211),
%imagesc(ja,ia,A);
imagesc(ja-j,ia-i,A);
axis xy, axis equal,
hold on
%imagesc(jb+j,ib+i,B);
imagesc(jb,ib,B);
axis xy, axis equal, axis tight
hold off
subplot(212), imagesc(ic,jc,C);
axis xy, axis equal, axis tight

end
