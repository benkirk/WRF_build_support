################################################################################
# useful sources, this will get them into 'make dist' but not install them...

noinst_SCRIPTS = build_autotools.sh torture.sh

noinst_DATA = \
	versions/stable.sh \
	versions/devel.sh \
	versions/default.sh

EXTRA_DIST = $(noinst_SCRIPTS) $(noinst_DATA)


torture:
	for conf in $(srcdir)/versions/*.sh; do \
	  testdir="$(abs_builddir)/$${conf}/"; \
	  $(MKDIR_P) $${testdir} && cd $${testdir} && pwd; \
	  BUILDCONF="$${conf}" $(abs_srcdir)/torture.sh; \
	done
