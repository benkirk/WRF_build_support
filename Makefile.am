# don't delete intermediate targets
.SECONDARY:


clobber:
	git clean -xdf --exclude utils/autotools --exclude import


# gcc/$(GCC_VERSION)/.dirstamp: gcc/build.sh build_config.sh
# 	$(AM_V_GEN)$(MKDIR_P) $(@D)
# 	$(AM_V_at)echo "Silly rule for $@ $(@D) $(COMPILER_ID_STRING) $(MPI_ID_STRING) PKG=$(<D) PKG_VERSION=${GCC_VERSION}"
# 	$(AM_V_at)echo "abs_top_builddir=$(abs_top_builddir)"
# 	$(AM_V_at)touch $@


%/$(GCC_VERSION): %/build.sh build_config.sh
	$(AM_V_GEN)$(MKDIR_P) $(@D)
	$(AM_V_at)BUILDCONF="$(abs_top_builddir)/build_config.sh" PKG="$(@D)" PKG_VERSION="$(@F)" $(srcdir)/$(@D)/build.sh
	$(AM_V_at)touch $@

%/$(ZLIB_VERSION)-$(COMPILER_ID_STRING) %/$(MPICH_VERSION)-$(COMPILER_ID_STRING) %/$(OPENMPI_VERSION)-$(COMPILER_ID_STRING): %/build.sh build_config.sh gcc/$(GCC_VERSION)
	$(AM_V_GEN)$(MKDIR_P) $(@D)
	$(AM_V_at)BUILDCONF="$(abs_top_builddir)/build_config.sh" PKG="$(@D)" PKG_VERSION="$$(echo $(@F) | cut -d '-' -f1)" PKG_COMPILER_ID="$(COMPILER_ID_STRING)" $(srcdir)/$(@D)/build.sh
	$(AM_V_at)touch $@
