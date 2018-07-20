function benchVD(timingFilename)
% function benchVD(timingFilename)
%
% Create a VOISE timing file timingFilename
% Don't forget to copy or link this file to 'VOISEtiming.mat'
%
% Note that it can takes VERY long time since a very large number of
% Voronoi diagrams are built with large number of seeds.

%
% $Id: benchVD.m,v 1.13 2018/05/30 16:20:22 patrick Exp $
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
%compileMEX
global voise

filename = strcat(voise.root, '/share/', timingFilename);
target = strcat(voise.root, '/share/', timingFilename, '.mat');
symlink = strcat(voise.root, '/share/VOISEtiming.mat');


numSeeds = 31;
begSeed = 2;
endSeed = 20;
% values for test purpose
%numSeeds = 10;
%endSeed = 300;
nr = 10;
nc = 10;

filename = strcat(voise.root, '/share/', num2str(nr), '-bench');

initSeeds = @randomSeeds;

% init seed of Mersenne-Twister RNG
rand('twister', 10);

if exist('initSeeds') & isa(initSeeds, 'function_handle'),
    [initSeeds, msg] = fcnchk(initSeeds);
    VDlim = setVDlim(nr, nc);
    S = initSeeds(nr, nc, endSeed, VDlim);
else
    error('initSeeds not defined or not a Function Handle');
end

fprintf(1, 'endSeed = %d card(S) = %d\n', endSeed, size(S, 1));
endSeed = size(S, 1);

nsf = round(logspace(log10(begSeed), log10(endSeed), numSeeds));
nsa = round(linspace(begSeed, endSeed, numSeeds));

% incremental batch add
nda = [nsa(1), diff(nsa)];
tVDa_cppb = zeros(size(nsa));
% initial seeds
s = S([1:nsa(1)], :);
tStart = tic;
VDa = computeVDCpp(nr, nc, s, VDlim);

lam = VDa.Vk.lambda;
V = VDa.Vk.v;
Nk = VDa.Nk;
fname_v = strcat("../cpp/src/test/resources/benchVDV", num2str(nr), ".txt");
fname_lam = strcat("../cpp/src/test/resources/benchVDLambda", num2str(nr), ".txt");
fname_seeds = strcat("../cpp/src/test/resources/benchVDSeeds", num2str(nr), ".txt");

save("Nk", "Nk");
save(fname_seeds, "S", "-ascii");
save(fname_v, "V", "-ascii");
save(fname_lam, "lam", "-ascii");
return;

tVDa_cppb(1) = toc(tStart);
fprintf(1, 'init   %4d seeds (%4d:%4d) %8.1f s\n', ...
    size(s, 1), 1, nsa(1), tVDa_cppb(1));

for i = 2:length(nsa)
    
    s = S([nsa(i-1) + 1:nsa(i)], :);
    ns = size(s, 1);
    tStart = tic;
    VDa = addSeedToVDBatch(VDa, s(1:ns, :));
    tVDa_cppb(i) = toc(tStart);
    fprintf(1, 'add    %4d seeds (%4d:%4d) %8.1f s\n', ...
        ns, nsa(i-1)+1, nsa(i), tVDa_cppb(i));
    
    if 0
        plot(nsa(1:i), tVDa(1:i)./nda(1:i));
        drawnow
    end
    
end

% incremental remove (batch)
nsr = nsa(end:-1:1);
ndr = -diff(nsr);
tVDr_cppb = zeros(size(nsr));
VDr = VDa;
for i = 1:length(nsr) - 1,
    
    sk = VDr.Sk([nsr(i):-1:nsr(i+1) + 1]);
    ns = length(sk);
    tStart = tic;
    VDr = removeSeedFromVDBatch(VDr, sk(1:ns));
    tVDr_cppb(i) = toc(tStart);
    
    fprintf(1, 'remove %4d seeds (%4d:%4d) %8.1f s\n', ...
        ns, nsr(i), nsr(i+1)+1, tVDr_cppb(i));
    
    if 0
        plot(nsr(1:i), tVDr_cppb(1:i)./ndr(1:i));
        drawnow
    end
    
end

% incremental add (C++ single)
nda = [nsa(1), diff(nsa)];
tVDa_cpps = zeros(size(nsa));
% initial seeds
s = S([1:nsa(1)], :);
tStart = tic;
VDa = computeVDCpp(nr, nc, s, VDlim);
tVDa_cpps(1) = toc(tStart);
fprintf(1, 'init   %4d seeds (%4d:%4d) %8.1f s\n', ...
    size(s, 1), 1, nsa(1), tVDa_cpps(1));

for i = 2:length(nsa)
    
    s = S([nsa(i-1) + 1:nsa(i)], :);
    ns = size(s, 1);
    tStart = tic;
    for k = 1:ns,
        VDa = addSeedToVD(VDa, s(k, :));
    end
    tVDa_cpps(i) = toc(tStart);
    fprintf(1, 'add    %4d seeds (%4d:%4d) %8.1f s\n', ...
        ns, nsa(i-1)+1, nsa(i), tVDa_cpps(i));
    
    if 0
        plot(nsa(1:i), tVDa_cpps(1:i)./nda(1:i));
        drawnow
    end
    
end

% incremental remove (C++ single)
nsr = nsa(end:-1:1);
ndr = -diff(nsr);
tVDr_cpps = zeros(size(nsr));
VDr = VDa;
for i = 1:length(nsr) - 1,
    
    sk = VDr.Sk([nsr(i):-1:nsr(i+1) + 1]);
    ns = length(sk);
    tStart = tic;
    for k = 1:ns,
        VDr = removeSeedFromVD(VDr, sk(k));
    end
    tVDr_cpps(i) = toc(tStart);
    
    fprintf(1, 'remove %4d seeds (%4d:%4d) %8.1f s\n', ...
        ns, nsr(i), nsr(i+1)+1, tVDr_cpps(i));
    
    if 0
        plot(nsr(1:i), tVDr_cpps(1:i)./ndr(1:i));
        drawnow
    end
    
end

% incremental add (matlab)
nda = [nsa(1), diff(nsa)];
tVDa_ml = zeros(size(nsa));
% initial seeds
s = S([1:nsa(1)], :);
tStart = tic;
VDa = computeVDCpp(nr, nc, s, VDlim);
%tVDa_ml(1) = toc(tStart);
fprintf(1, 'init   %4d seeds (%4d:%4d) %8.1f s\n', ...
    size(s, 1), 1, nsa(1), tVDa_ml(1));

for i = 2:length(nsa)
    
    s = S([nsa(i-1) + 1:nsa(i)], :);
    ns = size(s, 1);
    tStart = tic;
    for k = 1:ns,
        VDa = addSeedToVD2(VDa, s(k, :));
    end
    tVDa_ml(i) = toc(tStart);
    fprintf(1, 'add    %4d seeds (%4d:%4d) %8.1f s\n', ...
        ns, nsa(i-1)+1, nsa(i), tVDa_ml(i));
    
    if 0
        plot(nsa(1:i), tVDa_ml(1:i)./nda(1:i));
        drawnow
    end
    
end

% incremental remove (matlab)
nsr = nsa(end:-1:1);
ndr = -diff(nsr);
tVDr_ml = zeros(size(nsr));
VDr = VDa;
for i = 1:length(nsr) - 1,
    
    sk = VDr.Sk([nsr(i):-1:nsr(i+1) + 1]);
    ns = length(sk);
    tStart = tic;
    for k = 1:ns,
        VDr = removeSeedFromVD2(VDr, sk(k));
    end
    tVDr_ml(i) = toc(tStart);
    
    fprintf(1, 'remove %4d seeds (%4d:%4d) %8.1f s\n', ...
        ns, nsr(i), nsr(i+1)+1, tVDr_ml(i));
    
    if 0
        plot(nsr(1:i), tVDr_ml(1:i)./ndr(1:i));
        drawnow
    end
    
end

% full algorithm
nsf = nsa
tVDf = zeros(size(nsf));
for i = 1:length(nsf)
    
    s = S([1:nsf(i)], :);
    ns = size(s, 1);
    tStart = tic;
    VDf = computeVDFast(nr, nc, s, VDlim);
    tVDf(i) = toc(tStart);
    fprintf(1, 'full   %4d seeds (%4d:%4d) %8.1f s\n', ...
        ns, 1, nsf(i), tVDf(i));
    
    if 0
        plot(nsf(1:i), tVDf(1:i));
        drawnow
    end
    
end


nsr(end) = [];
tVDr_ml(end) = [];
tVDr_cppb(end) = [];
tVDr_cpps(end) = [];

tVDa_cppb = tVDa_cppb(2:end);
tVDa_cpps = tVDa_cpps(2:end);
tVDa_ml = tVDa_ml(2:end);
nda = nda(2:end)
nsa = nsa(2:end)

[ptVDf] = polyfit([0, nsf], [0, tVDf], 2);
[ptVDa] = polyfit([0, nsa], [0, tVDa_ml ./ nda], 1);
[ptVDr] = polyfit([nsr, 0], [tVDr_ml ./ ndr, 0], 1);

[ptVDa_cpps] = polyfit([nsa], [tVDa_cpps ./ nda], 1);
[ptVDr_cpps] = polyfit([nsr], [tVDr_cpps ./ ndr], 1);

[ptVDa_cppb] = polyfit([nsa], [tVDa_cppb ./ nda], 1);
[ptVDr_cppb] = polyfit([nsr], [tVDr_cppb ./ ndr], 1);

subplot(221),
plot(nsa, [tVDa_ml ./ nda; polyval(ptVDa, nsa)], '-o', ...
    nsr, [tVDr_ml ./ ndr; polyval(ptVDr, nsr)], '-o');
legend('Add', 'Add fit', 'Remove', 'Remove fit', 'location', 'northwest')
xlabel('number of seeds')
ylabel('time [s]')
title('Incremental VOISE')

subplot(222),
plot(nsf, [tVDf; polyval(ptVDf, nsf)], '-o');
xlabel('number of seeds')
ylabel('time [s]')
title('Full VOISE')

subplot(223),
plot(nsa, [tVDa_cpps ./ nda; polyval(ptVDa_cpps, nsa)], '-o', ...
    nsr, [tVDr_cpps ./ ndr; polyval(ptVDr_cpps, nsr)], '-o');
legend('Add', 'Add fit', 'Remove', 'Remove fit', 'location', 'northwest')
xlabel('number of seeds')
ylabel('time [s]')
title('C++ (Single job)')

subplot(224),
plot(nsa, [tVDa_cppb ./ nda; polyval(ptVDa_cppb, nsa)], '-o', ...
    nsr, [tVDr_cppb ./ ndr; polyval(ptVDr_cppb, nsr)], '-o');
legend('Add', 'Add fit', 'Remove', 'Remove fit', 'location', 'northwest')
xlabel('number of seeds')
ylabel('time [s]')
title('C++ (Batch job)')


fprintf(1, 'Saving timings in timing file:\n %s\n', ...
    filename);

save(filename, 'nsf', 'tVDf', 'ptVDf', ...
    'nsa', 'nda', 'tVDa_ml', 'ptVDa', 'nsr', 'ndr', 'tVDr_ml', 'ptVDr', ...
    'tVDa_cpps', 'ptVDa_cpps', 'tVDr_cpps', 'ptVDr_cpps', ...
    'tVDa_cppb', 'ptVDa_cppb', 'tVDr_cppb', 'ptVDr_cppb');

fprintf(1, 'You should copy / link it to the VOISE timing file:\n %s\n', ...
    filename);

cmd = ['ln -s ', target, ' ', symlink];
fprintf(1, 'Creating symbolic link for you..:\n%s\n', join(cmd));
unix(join(cmd));
