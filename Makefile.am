# don't delete intermediate targets
.SECONDARY:


clobber:
	git clean -xdf --exclude utils/autotools --exclude import


# gcc/$(GCC_VERSION)/.dirstamp: gcc/build.sh build_config.sh
# 	$(AM_V_GEN)$(MKDIR_P) $(@D)
# 	$(AM_V_at)echo "Silly rule for $@ $(@D) $(COMPILER_ID_STRING) $(MPI_ID_STRING) PKG=$(<D) PKG_VERSION=${GCC_VERSION}"
# 	$(AM_V_at)echo "abs_top_builddir=$(abs_top_builddir)"
# 	$(AM_V_at)touch $@


%/config_env.sh: %
	$(MAKE) $(@D)

%/$(GCC_VERSION)/: %/build.sh
	$(AM_V_GEN) \
	  BUILDCONF="$(abs_top_builddir)/build_config.sh" \
          PKG="$$(echo '$(@D)' | cut -d '/' -f1)" \
          PKG_VERSION="$$(echo '$(@D)' | cut -d '/' -f2)" \
          PKG_INSTALL_PREFIX="$(abs_builddir)/$(@)" \
	  $(<)

%/$(ZLIB_VERSION)-$(COMPILER_ID_STRING)/ %/$(MPICH_VERSION)-$(COMPILER_ID_STRING)/ %/$(OPENMPI_VERSION)-$(COMPILER_ID_STRING)/: %/build.sh gcc/$(GCC_VERSION)/config_env.sh
	$(AM_V_GEN) \
	  source gcc/$(GCC_VERSION)/config_env.sh && \
	  BUILDCONF="$(abs_top_builddir)/build_config.sh" \
	  PKG="$$(echo '$(@D)' | cut -d '/' -f1)" \
	  PKG_VERSION="$$(echo '$(@D)' | cut -d '/' -f2 | cut -d '-' -f1)" \
	  PKG_INSTALL_PREFIX="$(abs_builddir)/$(@)" \
	  PKG_COMPILER_ID="$(COMPILER_ID_STRING)" \
	  $(<)

%/$(HDF5_VERSION)-$(COMPILER_ID_STRING)/: %/build.sh gcc/$(GCC_VERSION)/config_env.sh zlib/$(ZLIB_VERSION)-$(COMPILER_ID_STRING)/config_env.sh
	$(AM_V_GEN) \
	  source gcc/$(GCC_VERSION)/config_env.sh && \
	  source zlib/$(ZLIB_VERSION)-$(COMPILER_ID_STRING)/config_env.sh && \
	  BUILDCONF="$(abs_top_builddir)/build_config.sh" \
	  PKG="$$(echo '$(@D)' | cut -d '/' -f1)" \
	  PKG_VERSION="$$(echo '$(@D)' | cut -d '/' -f2 | cut -d '-' -f1)" \
	  PKG_INSTALL_PREFIX="$(abs_builddir)/$(@)" \
	  PKG_COMPILER_ID="$(COMPILER_ID_STRING)" \
	  $(<)
