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
clc; clear all; format compact;
global voise

%filename = strcat(voise.root, '/share/', timingFilename);
%target = strcat(voise.root, '/share/', timingFilename, '.mat');
%symlink = strcat(voise.root, '/share/VOISEtiming.mat');


numSeeds = 41;
begSeed = 3;
endSeed = 4003;
% values for test purpose
%numSeeds = 10;
%endSeed = 300;
r = 0;
for x = [128 256 512 1024]
    r = r + 1;
    %nr = 128;
    %nc = 128;
    nr = x;
    nc = x;

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
    % save("benchVDSeeds.txt", "S", "-ascii");
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
    nsr(end) = [];
    tVDr_cppb(end) = [];
    nsa = nsa';
    ndr = ndr';
    nsr = nsr';
    nda = nda';
    
    tVDa_cppb = tVDa_cppb';
    tVDr_cppb = tVDr_cppb';

    [ptVDa_cppb] = polyfit([nsa(4:end)], [tVDa_cppb(4:end) ./ nda(4:end)], 1);
    [ptVDr_cppb] = polyfit([nsr(1:end-4)], [tVDr_cppb(1:end-4) ./ ndr(1:end-4)], 1);
    
    subplotbase = '22';
    subplotstr = strcat(subplotbase, num2str(r));
    subplotint = str2num(subplotstr);
    subplot(subplotint)
        %plot(ptVDa_cppb(nsa)), nsa, tVDa_cppb./nsa, '-x');
        
%        plot(nsa(2:end), [tVDa_cppb(2:end)], 'bx', 'linewidth', 1);
        %plot(nsa, polyval(ptVDa_cppb, nsa), 'b-');
        
        plot(nsa(2:end), tVDa_cppb(2:end)./nda(2:end), 'bo', 'markersize', 5,...
            'MarkerFaceColor', 'b')
        hold on;
        plot(nsa(2:end), polyval(ptVDa_cppb, nsa(2:end)), 'b-');
        hold on;
        plot(nsr, tVDr_cppb./ndr, 'ro', 'markersize', 5, 'MarkerFaceColor', 'r');
        hold on;
        plot(nsr, polyval(ptVDr_cppb, nsr), 'r-');
        hold on;
        %plot(nsr, polyval(ptVDr_cppb, nsr), 'r-')
        
        xlabel('Number of seeds')
        ylabel('Time [s]')
        xlim([0 3010]);
        ylim([0 2e-3]);
        title('Add seed')
        hold on;
        %plot(ptVDr_cppb(nsr))%, nsr, tVDr_cppb./nsr, '-x');
        %plot(nsr, tVDr_cppb, 'r-x', 'linewidth', 1);
        %plot(flipud(nsr), polyval(ptVDr_cppb, nsr));
        xlabel('Number of seeds');
        ylabel('Time per seed [s]');
        titlestr = strcat(int2str(nr), " x ", int2str(nr));
        title(titlestr);
        legend('Add measured','Add linear fit','Remove measured','Remove linear fit','location','northeast')

end
set(gcf, 'Position', [500, 500, 2000, 2000])
print("../../../../project-docs/report/images/graphs/grids", "-depsc", '-r1000');
return
if 0
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
end
nsr(end) = [];
tVDr_cppb(end) = [];
%tVDr_cpps(end) = [];
nsa = nsa';
ndr = ndr';
nsr = nsr';
nda = nda';
%tVDa_cpps = tVDa_cpps';
%tVDr_cpps = tVDr_cpps';
tVDa_cppb = tVDa_cppb';
tVDr_cppb = tVDr_cppb';

%[ptVDa_cpps] = polyfit([nsa], [tVDa_cpps ./ nda], 1);
%[ptVDa_cpps] = fit(nsa, tVDa_cpps ./ nsa, 'power2')
%[ptVDr_cpps] = fit(nsr, tVDr_cpps ./ ndr, 'power2')

[ptVDa_cppb] = fit([nsa], [tVDa_cppb ./ nda], 'power2')
[ptVDr_cppb] = fit([nsr], [tVDr_cppb ./ ndr], 'power2')

if 0
subplot(121),
%plot(nsa, [tVDa_cpps ./ nda], '-o', ...
    %nsr, [tVDr_cpps ./ ndr], '-o');
hold on;
plot(ptVDa_cpps, nsa, tVDa_cpps./nsa, '-x');
hold on;
plot(ptVDr_cpps, nsr, tVDr_cpps./nsr, '-x');
legend('Add', 'Remove', 'Add fit', 'Remove fit', 'location', 'northwest')
xlabel('number of seeds')
ylabel('time [s]')
title('C++ (Single job)')
end
%subplot(122),
%plot(nsa, [tVDa_cppb ./ nda], '-o', ...
%    nsr, [tVDr_cppb ./ ndr], '-o');
%hold on;
plot(ptVDa_cppb, '-x')%, nsa, tVDa_cppb./nsa, '-x');
hold on;
plot(ptVDr_cppb, '-x')%, nsr, tVDr_cppb./nsr, '-x');
legend('Add', 'Remove', 'Add fit', 'Remove fit', 'location', 'northwest')
xlabel('number of seeds')
ylabel('time [s]')
title('C++ (Batch job)')