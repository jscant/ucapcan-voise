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



% values for test purpose
%numSeeds = 10;
%endSeed = 300;
r = 0;
nc = 512
nr = 512
for x = [2 10 100 200]
    r = r + 1;
    
    begSeed = 3;
    endSeed = 4003;
    numSeeds = 4000/x + 1;
    
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

    if (0 <= x) && (x < 10)
            trim = 10;
        elseif (10 <= x) && (x < 100)
                trim = 4;
        else
            trim = 4;
    end
        
    [ptVDa_cppb] = polyfit([nsa(trim:end)], [tVDa_cppb(trim:end) ./ nda(trim:end)], 1);
    [ptVDr_cppb] = polyfit([nsr(1:end-trim)], [tVDr_cppb(1:end-trim) ./ ndr(1:end-trim)], 1);
    
    subplotbase = '22';
    subplotstr = strcat(subplotbase, num2str(r));
    subplotint = str2num(subplotstr);
    subplot(subplotint)
        if (0 <= x) && (x < 10)
            ms = 0.3;
        elseif (10 <= x) && (x < 100)
                ms = 1;
        else
            ms = 2;
        end
    
        plot(nsa(2:end), tVDa_cppb(2:end)./nda(2:end), 'bo', 'markersize', ms,...
            'MarkerFaceColor', 'b')
        hold on;
        plot(nsa(2:end), polyval(ptVDa_cppb, nsa(2:end)), 'b-');
        hold on;
        plot(nsr, tVDr_cppb./ndr, 'ro', 'markersize', ms, 'MarkerFaceColor',...
            'r');
        hold on;
        plot(nsr, polyval(ptVDr_cppb, nsr), 'r-');
        hold on;

        xlim([0 4010]);
        ylim([0 inf]);
        title('Add seed')
        hold on;

        xlabel('Number of seeds');
        ylabel('Time per seed [s]');
        titlestr = strcat("Batch size: ", int2str(x));
        title(titlestr);
        legend('Add measured','Add linear fit','Remove measured',...
            'Remove linear fit','location','southeast')
            

end
set(gcf, 'Position', [500, 500, 2000, 2000])
%print("../../../../project-docs/report/images/graphs/batchsize256", "-depsc", '-r10000');
return
