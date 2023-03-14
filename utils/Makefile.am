################################################################################
# the 'use_stack.sh' script can be sourced to use the build environment.
# is is generted by 'configure' and installed into the root of the
# installation prefix by 'make install'

confscriptdir = $(prefix)
confscript_DATA = use_stack.sh
#data_DATA = use_stack.sh



################################################################################
# useful sources, this will get them into 'make dist' but not install them...

noinst_SCRIPTS = build_autotools.sh torture.sh

noinst_DATA = \
	versions/stable.sh \
	versions/devel.sh \
	versions/default.sh

EXTRA_DIST = $(noinst_SCRIPTS) $(noinst_DATA)


torture:
	for conf in $(abs_srcdir)/versions/*.sh; do \
	  testdir="$(abs_builddir)/$${conf}/"; \
	  $(MKDIR_P) $${testdir} && cd $${testdir} && pwd; \
	  BUILDCONF="$${conf}" $(abs_srcdir)/torture.sh; \
	done
