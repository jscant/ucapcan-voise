function benchVD()
% function benchVD()
% 
% Create a VOISE timing file 'VOISEtiming.mat'
%
% Note that it can takes VERY long time since a very large number of 
% Voronoi diagrams are built with large number numbers of seeds.

%
% $Id: benchVD.m,v 1.12 2015/02/11 17:50:02 patrick Exp $
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

numSeeds = 40;
begSeed = 5;
endSeed = 3000;
% values for test purpose
%numSeeds = 10;
%endSeed = 300;
nr = 256;
nc = 256;

nsf = round(logspace(log10(begSeed), log10(endSeed), numSeeds));
nsa = round(linspace(begSeed, endSeed, numSeeds));

initSeeds = @randomSeeds;

% init seed of Mersenne-Twister RNG
rand('twister',10);

if exist('initSeeds') & isa(initSeeds, 'function_handle'),
  [initSeeds, msg] = fcnchk(initSeeds);
  [S,VDlim] = initSeeds(nr, nc, endSeed);
else
  error('initSeeds not defined or not a Function Handle');
end

% full algorithm
tVDf = zeros(size(nsf));
for i=1:length(nsf)

  s = S([1:nsf(i)],:);
	ns = size(s,1);
  tStart = tic;
  VDf = computeVDFast(nr, nc, s, VDlim);
  tVDf(i) = toc(tStart);
  fprintf(1,'full   %4d seeds (%4d:%4d) %8.1f s\n', ...
	        ns, 1, nsf(i), tVDf(i));

  if 0
  plot(nsf(1:i), tVDf(1:i));
	drawnow
	end

end

% incremental add
nda = [nsa(1), diff(nsa)];
tVDa = zeros(size(nsa));
% initial seeds
s = S([1:nsa(1)],:);
tStart = tic;
VDa = computeVD(nr, nc, s, VDlim);
tVDa(1) = toc(tStart);
fprintf(1,'init   %4d seeds (%4d:%4d) %8.1f s\n', ...
        size(s,1), 1, nsa(1), tVDa(1));

for i=2:length(nsa)

  s = S([nsa(i-1)+1:nsa(i)],:);
	ns = size(s,1);
  tStart = tic;
  for k = 1:ns,
    VDa = addSeedToVD(VDa, s(k,:));
	end
  tVDa(i) = toc(tStart);
  fprintf(1,'add    %4d seeds (%4d:%4d) %8.1f s\n', ...
          ns, nsa(i-1)+1, nsa(i), tVDa(i));

  if 0
  plot(nsa(1:i), tVDa(1:i)./nda(1:i));
	drawnow
	end

end

% incremental remove
nsr = nsa(end:-1:1);
ndr = -diff(nsr);
tVDr = zeros(size(nsr));
VDr = VDa;
for i=1:length(nsr)-1,
  
  sk = VDr.Sk([nsr(i):-1:nsr(i+1)+1]);
	ns = length(sk);
  tStart = tic;
  for k = 1:ns,
    VDr = removeSeedFromVD(VDr, s(k,:));
	end
  tVDr(i) = toc(tStart);

  fprintf(1,'remove %4d seeds (%4d:%4d) %8.1f s\n', ...
	        ns, nsr(i), nsr(i+1)+1, tVDr(i));

  if 0
  plot(nsr(1:i), tVDr(1:i)./ndr(1:i));
	drawnow
	end

end
nsr(end) = [];
tVDr(end) = [];

[ptVDf] = polyfit([0 nsf], [0 tVDf], 2);
[ptVDa] = polyfit([0 nsa], [0 tVDa./nda], 1);
[ptVDr] = polyfit([nsr 0], [tVDr./ndr 0], 1);

subplot(211),
plot(nsa, [tVDa./nda; polyval(ptVDa,nsa)], '-o', ...
		 nsr, [tVDr./ndr; polyval(ptVDr,nsr)], '-o');
legend('Add','Add fit','Remove','Remove fit','location','northwest')
xlabel('number of seeds')
ylabel('time [s]')
title('Incremental VOISE')

subplot(212),
plot(nsf, [tVDf; polyval(ptVDf,nsf)], '-o');
xlabel('number of seeds')
ylabel('time [s]')
title('Full VOISE')


save([voise.root '/share/VOISEtiming.mat'],'nsf','tVDf','ptVDf', ...
     'nsa','nda','tVDa','ptVDa','nsr','ndr','tVDr','ptVDr');

