
if HAVE_MCC

mccVOISE: VOISE gVOISE verifyImage

MCCFLAGS = -m -v
MCCFLAGSNODISPLAY = -R '-nodisplay' -m -v
MCCFLAGSNOJVM = -R '-nojvm,-nodisplay' -m -v

matlabdir = $(top_srcdir)/matlab

VOISE_SRC = \
$(matlabdir)/webVOISE.m \
$(matlabdir)/startup.m \
$(matlabdir)/addSeedsToVR.m \
$(matlabdir)/addSeedToVD.m \
$(matlabdir)/mergeVD.m \
$(matlabdir)/benchVD.m \
$(matlabdir)/parseArgs.m \
$(matlabdir)/computeHCThreshold.m \
$(matlabdir)/plotHistHC.m \
$(matlabdir)/computeVDFast.m \
$(matlabdir)/plotVOISE.m \
$(matlabdir)/computeVD.m \
$(matlabdir)/prctile.m \
$(matlabdir)/divideVD.m \
$(matlabdir)/printFigure.m \
$(matlabdir)/printSeeds.m \
$(matlabdir)/getCentroidSeed.m \
$(matlabdir)/printSet.m \
$(matlabdir)/getCentroidVD.m \
$(matlabdir)/printVD.m \
$(matlabdir)/getDefaultVOISEParams.m \
$(matlabdir)/readVOISEconf.m \
$(matlabdir)/printVOISEsetup.m \
$(matlabdir)/getEquidistantPoint.m \
$(matlabdir)/setVDlim.m \
$(matlabdir)/shakeSeeds.m \
$(matlabdir)/randomSeeds.m \
$(matlabdir)/poissonSeeds.m \
$(matlabdir)/uniformSeeds.m \
$(matlabdir)/boardSeeds.m \
$(matlabdir)/getVDOp.m \
$(matlabdir)/removeSeedFromVD.m \
$(matlabdir)/getVRclosure.m \
$(matlabdir)/seedDist.m \
$(matlabdir)/getVRvertices.m \
$(matlabdir)/homogeneousCriteria.m \
$(matlabdir)/updateNeighboursListsFromVoronoin.m \
$(matlabdir)/initVD.m \
$(matlabdir)/VOISE.m \
$(matlabdir)/isXinW.m \
$(matlabdir)/loadImage.m \
$(matlabdir)/fitswrite.m \
$(matlabdir)/imageUtils/filterImage.m \
$(matlabdir)/imageUtils/histEq.m


VERIFYIMAGE_SRC = \
$(matlabdir)/verifyImage.m \
$(matlabdir)/loadImage.m \
$(matlabdir)/startup.m

VOISE: $(VOISE_SRC)
	$(MCC) $(MCCFLAGSNODISPLAY) $^ -o $@
	mv readme.txt readme-VOISE.txt
	mv mccExcludedFiles.log mccExcludedFiles-VOISE.log
	-rm -f *.o*

gVOISE: $(VOISE_SRC)
	$(MCC) $(MCCFLAGS) $^ -o $@
	mv readme.txt readme-gVOISE.txt
	mv mccExcludedFiles.log mccExcludedFiles-gVOISE.log
	-rm -f *.o*

verifyImage: $(VERIFYIMAGE_SRC)
	$(MCC) $(MCCFLAGSNOJVM) $^ -o $@
	mv readme.txt readme-verifyImage.txt
	mv mccExcludedFiles.log mccExcludedFiles-verifyImage.log
	-rm -f *.o*


gdemo1: gVOISE
	@echo "*********** testing gVOISE demo1 ***********"
	./run_gVOISE.sh $(MATLABROOT) ../share/VOISEdemo1.dat

gdemo2: gVOISE
	@echo "*********** testing gVOISE demo2 ***********"
	./run_gVOISE.sh $(MATLABROOT) ../share/VOISEdemo2.dat

demo1: VOISE
	@echo "*********** testing VOISE demo1 ***********"
	./run_VOISE.sh $(MATLABROOT) ../share/VOISEdemo1.dat

demo2: VOISE
	@echo "*********** testing VOISE demo2 ***********"
	./run_VOISE.sh $(MATLABROOT) ../share/VOISEdemo2.dat

gcheck: gdemo1 gdemo2
check: demo1 demo2

endif

clean-local:
	-rm -f *VOISE* *verifyImage* *startup* *.log readme.txt

