load ../share/VOISEtiming.mat

subplot(221),
plot(nsa, [tVDa_ml./nda; polyval(ptVDa,nsa)], '-o', ...
		 nsr, [tVDr_ml./ndr; polyval(ptVDr,nsr)], '-o');
legend('Add','Add fit','Remove','Remove fit','location','northwest')
xlabel('number of seeds')
ylabel('time [s]')
title('Incremental VOISE')

subplot(222),
plot(nsf, [tVDf; polyval(ptVDf,nsf)], '-o');
xlabel('number of seeds')
ylabel('time [s]')
title('Full VOISE')

subplot(223),
plot(nsa, [tVDa_cpps./nda; polyval(ptVDa_cpps,nsa)], '-o', ...
		 nsr, [tVDr_cpps./ndr; polyval(ptVDr_cpps,nsr)], '-o');
legend('Add','Add fit','Remove','Remove fit','location','northwest')
xlabel('number of seeds')
ylabel('time [s]')
title('C++ (Single job)')

subplot(224),
plot(nsa, [tVDa_cppb./nda; polyval(ptVDa_cppb,nsa)], '-o', ...
		 nsr, [tVDr_cppb./ndr; polyval(ptVDr_cppb,nsr)], '-o');
legend('Add','Add fit','Remove','Remove fit','location','northwest')
xlabel('number of seeds')
ylabel('time [s]')
title('C++ (Batch job)')

figure;
subplot(221)
pvslow = polyval(ptVDa,nsa);
pvfast = polyval(ptVDa_cppb,nsa);
diff = pvslow./pvfast;
plot(nsa(1:length(nsa)), diff(1:length(nsa)));
ylim([0, 1.1*max(diff)]);
xlabel('number of seeds')
ylabel('Incremental (s) / SKIZ (s)')
title("CPU time: Incremental/SKIZ (Add)")

subplot(222)
pvslow = polyval(ptVDf,nsa);
pvfast = polyval(ptVDa_cppb,nsa);
diff = pvslow./pvfast;
plot(nsa(1:length(nsa)), diff(1:length(nsa)));
ylim([0, 1.1*max(diff)]);
xlabel('number of seeds')
ylabel('Full (s) / SKIZ (s)')
title("CPU time: Full/SKIZ (Add)")

subplot(223)
pvslow = polyval(ptVDr,nsa);
pvfast = polyval(ptVDr_cppb,nsa);
diff = pvslow./pvfast;
plot(nsa(1:length(nsa)), diff(1:length(nsa)));
ylim([0, 1.1*max(diff)]);
xlabel('number of seeds')
ylabel('Incremental (s) / SKIZ (s)')
title("CPU time: Incremental/SKIZ (Remove)")

subplot(224)
pvslow = polyval(ptVDf,nsa);
pvfast = polyval(ptVDr_cppb,nsa);
diff = pvslow./pvfast;
plot(nsa(1:length(nsa)), diff(1:length(nsa)));
ylim([0, 1.1*max(diff)]);
xlabel('number of seeds')
ylabel('Full (s) / SKIZ (s)')
title("CPU time: Full/SKIZ (Remove)")