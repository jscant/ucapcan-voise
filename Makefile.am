

SUBDIRS = matlab mcc share doc

EXTRA_DIST = LICENSE mcc/Makefile 

update-cl:
	update-cl.sh

if HAVE_MCC

ROOT = mcc@PACKAGE_NAME@-@VERSION@-@target@

mccVOISE:
	@(cd mcc && $(MAKE) $(AM_MAKEFLAGS) $@) || exit 1;

webdemo1 webdemo2 demo1 demo2 check checkweb: mccVOISE
	@(cd mcc && $(MAKE) $(AM_MAKEFLAGS) $@) || exit 1;

dist-mccVOISE: mccVOISE
	@rm -rf $(ROOT)
	@mkdir -p $(ROOT) $(ROOT)/mcc $(ROOT)/share $(ROOT)/share/input $(ROOT)/share/output $(ROOT)/doc
	@cp -pr AUTHORS ChangeLog NEWS README $(ROOT)
	@cp -pr mcc/Makefile mcc/*VOISE* mcc/*verifyImage* mcc/README $(ROOT)/mcc
	@cp -p share/VOISEtiming.mat share/VOISEdemo*.dat $(ROOT)/share
	@cp -p share/input/north_proj.mat $(ROOT)/share/input
	@cp -p share/input/sampleint.fits $(ROOT)/share/input
	@cp -p share/input/STIS_orbit_17.fits $(ROOT)/share/input
	@cp -p doc/j_1365-2966_2009_15218.pdf $(ROOT)/doc
	@cp -p doc/limbfit-draft.pdf $(ROOT)/doc
	@cp -p doc/poster-agufm09.pdf $(ROOT)/doc
	@cp -p doc/poster-agufm12.pdf $(ROOT)/doc
	@tar -cvf $(ROOT).tar $(ROOT)
	@bzip2 -9 $(ROOT).tar
	@rm -rf $(ROOT)

endif

