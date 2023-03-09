# foo


clobber:
	git clean -xdf --exclude utils/autotools --exclude import


gcc/$(GCC_VERSION)/.dirstamp: gcc/build.sh build_config.sh Makefile
	$(AM_V_GEN)$(MKDIR_P) $(@D)
	$(AM_V_at)echo "Silly rule for $@ $(@D) $(COMPILER_ID_STRING) $(MPI_ID_STRING) PKG=$(<D) PKG_VERSION=${GCC_VERSION}"
	$(AM_V_at)echo "abs_top_builddir=$(abs_top_builddir)"
	$(AM_V_at)touch $@


gcc/$(GCC_VERSION) mpich/$(MPICH_VERSION) openmpi/$(OPENMPI_VERSION): build_config.sh Makefile
	$(AM_V_GEN)$(MKDIR_P) $(@D)
	$(AM_V_at)echo "Silly rule for $@ $(COMPILER_ID_STRING) $(MPI_ID_STRING) PKG=$(@D) PKG_VERSION=$(@F)"
	$(AM_V_at)echo "abs_top_builddir=$(abs_top_builddir)"
	$(AM_V_at)BUILDCONF="$(abs_top_builddir)/build_config.sh" PKG=$(@D) PKG_VERSION=$(@F) $(@D)/build.sh
	$(AM_V_at)touch $@
