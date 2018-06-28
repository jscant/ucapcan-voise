#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.63])
AC_INIT([VOISE], [1.3.2], [p.guio@ucl.ac.uk])
AC_CONFIG_SRCDIR([matlab/divideVD.m])
dnl AC_CONFIG_HEADERS([config.h])

AC_CANONICAL_TARGET

AM_INIT_AUTOMAKE([1.11 dist-bzip2])

dnl Avoid generating makefile rules to rebuild maintainer-only files by
dnl default.  Maintainers may override this default and generate these
dnl makefile rules using the `--enable-maintainer-mode' configure option.
AM_MAINTAINER_MODE

AC_MSG_NOTICE
AC_MSG_NOTICE([Configuring $PACKAGE_STRING for $target])
AC_MSG_NOTICE

# Get and set MATLABROOT variable
AC_ARG_VAR(MATLABROOT,[MATLAB software root installation])
if test -z "$MATLABROOT"; then 
  AC_MSG_CHECKING([MATLAB software root installation])
  cat >> mroot.m << EOF
fprintf(1,'\nMATLABROOT=%s\n',matlabroot);
exit;
EOF
  which matlab &> /dev/null || (echo "matlab command not found" && exit 1)
	matlab -nodesktop -nojvm -nosplash -nodisplay < mroot.m | grep MATLABROOT > mroot.out
	MATLABROOT=`sed 's/MATLABROOT=//' mroot.out`
	rm -f mroot.m mroot.out
	AC_MSG_RESULT([$MATLABROOT])
fi
AC_SUBST(MATLABROOT)

# Checks for programs.
AC_CHECK_PROG([MCC],[mcc],[mcc])
if test -z "$MCC"; then
  AC_PATH_PROG([MCC],[mcc],[""],[$MATLABROOT/bin])
fi
AM_CONDITIONAL([HAVE_MCC],[test -n "$MCC"])

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.



dnl Generate Makefiles
AC_CONFIG_FILES([Makefile matlab/Makefile mcc/Makefile share/Makefile doc/Makefile])

AC_CONFIG_FILES([matlab/start_VOISE.m:matlab/start_VOISE.m.in], [])

AC_CONFIG_FILES([matlab/webVOISE.m:matlab/webVOISE.m.in], [])

AC_OUTPUT

AC_MSG_NOTICE([

The configure script has set up the MATLAB version of VOISE.
])

if test  -n "$MCC"; then 
AC_MSG_NOTICE([

You have further options available since the MATLAB compiler mcc is available

  make mccVOISE        Compile standalone VOISE with MATLAB compiler mcc
  make dist-mccVOISE   Create standalone distro for this architecture
  make demo1           Run demo1 without graphic diagnostic
  make demo2           Run demo2 without graphic diagnostic
  make check           Run demo1 and demo2 
  make gdemo1          Run demo1 with graphic diagnostic
  make gdemo2          Run demo2 with graphic diagnostic
  make gcheck          Run gdemo1 and gdemo2
])
else
AC_MSG_NOTICE([

The MATLAB compiler mcc was not detected, VOISE cannot be compiled as a
standalone application

])
fi
