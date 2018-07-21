load ../share/512-bench.mat
box on
[ptVDa_cppb] = polyfit([nsa(4:end)], [tVDa_cppb(4:end) ./ nda(4:end)], 1);
[ptVDr_cppb] = polyfit([nsr(1:end-4)], [tVDr_cppb(1:end-4) ./ ndr(1:end-4)], 1);

fs = 16

ha = tight_subplot(2, 2, 0.1, 0.06, 0.06)

axes(ha(1));
%subplot(221)
%plot(nsa, [tVDa_ml./nda; polyval(ptVDa,nsa)], '-o', ...
%		 nsr, [tVDr_ml./ndr; polyval(ptVDr,nsr)], '-o');
     

plot(nsa, tVDa_ml./nda, 'bx', 'markersize', 5)
hold on;
plot(nsa, polyval(ptVDa, nsa), 'b-');
hold on;
plot(nsr, tVDr_ml./ndr, 'rd', 'markersize', 5);
hold on;
plot(nsr, polyval(ptVDr, nsr), 'r-');
legend({'Add measured','Add linear fit','Remove measured','Remove linear fit'},'location','northwest',...
    'FontSize', fs)
xlabel('Number of seeds')
ylabel('Time [s]')
title('Matlab (Incremental)')
xlim([0 3005])


%subplot(222),
axes(ha(2));
plot(nsf, [tVDf; polyval(ptVDf,nsf)], '-o');

diffnsf = diff(nsf);
tVDf = tVDf(2:end);
nsf = nsf(2:end);

ptVDf = polyfit(nsf', tVDf'./diffnsf', 2)
plot(nsf, tVDf./diffnsf, 'kx', 'markersize', 5)
hold on;
plot(nsf, polyval(ptVDf, nsf), 'k-');
hold on;

legend({'Full measured', 'Full quadratic fit'}, 'location', 'northwest', 'FontSize', fs);
xlabel('Number of seeds')
ylabel('Time [s]')
title('QHull (Full)')
xlim([0 3005])

%subplot(223),
axes(ha(3));
plot(nsa, [tVDa_cpps./nda; polyval(ptVDa_cpps,nsa)], '-o', ...
		 nsr, [tVDr_cpps./ndr; polyval(ptVDr_cpps,nsr)], '-o');
     
plot(nsa, tVDa_cpps./nda, 'bx', 'markersize', 5)
hold on;
plot(nsa, polyval(ptVDa_cpps, nsa), 'b-');
hold on;
plot(nsr, tVDr_cpps./ndr, 'rd', 'markersize', 5);
hold on;
plot(nsr, polyval(ptVDr_cpps, nsr), 'r-');
xlim([0 3005])
ylim([0 0.014])

legend({'Add measured','Add linear fit','Remove measured','Remove linear fit'},'location','southeast', 'FontSize', fs)
xlabel('Number of seeds')
ylabel('Time per seed [s]');
title('SKIZ C++ (Single)')

%subplot(224)
axes(ha(4));

plot(nsa, tVDa_cppb./nda, 'bx', 'markersize', 5)
hold on;
plot(nsa, polyval(ptVDa_cppb, nsa), 'b-');
hold on;
plot(nsr, tVDr_cppb./ndr, 'rd', 'markersize', 5);
hold on;
plot(nsr, polyval(ptVDr_cppb, nsr), 'r-');
hold off;
legend({'Add measured','Add linear fit','Remove measured','Remove linear fit'},'location','northeast', 'FontSize', fs);
xlabel('Number of seeds')
ylabel('Time [s]')
ylim([0, 6e-4]);
xlim([0 3005])
title('SKIZ C++ (Batch)')
a = findall(0,'type', 'axes');
delete(a(5))
set(gcf, 'Position', [500, 500, 2000, 2000])
print("../../../../project-docs/report/images/graphs/512", "-depsc", '-r1000');



return
figure;
subplot(221)
pvslow = polyval(ptVDa,nsa);
pvfast = polyval(ptVDa_cppb,nsa);
diff = pvslow./pvfast;
max(diff)
min(diff)
plot(nsa(1:length(nsa)), diff(1:length(nsa)));
ylim([0, 1.1*max(diff)]);
xlabel('Number of seeds')
ylabel('Incremental (s) / SKIZ (s)')
title("Time: Incremental/SKIZ (Add)")

subplot(222)
pvslow = polyval(ptVDf,nsa);
pvfast = polyval(ptVDa_cppb,nsa);
diff = pvslow./pvfast;
max(diff)
min(diff)
plot(nsa(1:length(nsa)), diff(1:length(nsa)));
ylim([0, 1.1*max(diff)]);
xlabel('Number of seeds')
ylabel('Full (s) / SKIZ (s)')
title("Time: Full/SKIZ (Add)")

subplot(223)
pvslow = polyval(ptVDr,nsa);
pvfast = polyval(ptVDr_cppb,nsa);
diff = pvslow./pvfast;
max(diff)
min(diff)
plot(nsa(1:length(nsa)), diff(1:length(nsa)));
ylim([0, 1.1*max(diff)]);
xlabel('Number of seeds')
ylabel('Incremental (s) / SKIZ (s)')
title("Time: Incremental/SKIZ (Remove)")

subplot(224)
pvslow = polyval(ptVDf,nsa);
pvfast = polyval(ptVDr_cppb,nsa);
diff = pvslow./pvfast;
max(diff)
min(diff)
plot(nsa(1:length(nsa)), diff(1:length(nsa)));
ylim([0, 1.1*max(diff)]);
xlabel('Number of seeds')
ylabel('Full (s) / SKIZ (s)')
title("Time: Full/SKIZ (Remove)")
