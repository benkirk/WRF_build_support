################################################################################
PKG = trilinos
PKG_VERSION = $(TRILINOS_VERSION)
PKG_BUILD_DEPS = $(top_builddir)/gcc/$(GCC_VERSION)/config_env.sh \
                 $(top_builddir)/cmake/$(CMAKE_VERSION)-$(COMPILER_ID)/config_env.sh \
                 $(top_builddir)/zlib/$(ZLIB_VERSION)-$(COMPILER_ID)/config_env.sh \
                 $(top_builddir)/hdf5/$(HDF5_VERSION)-$(COMPILER_ID)/config_env.sh \
                 $(top_builddir)/$(MPI_FAMILY)/$(MPI_VERSION)-$(COMPILER_ID)/config_env.sh \
                 $(top_builddir)/petsc/$(PETSC_VERSION)-$(MPI_ID)/config_env.sh

include $(top_srcdir)/rules/Make.pkg_deps

# Things that depend on MPI:
BUILT_SOURCES = $(PKG_VERSION)-$(MPI_ID)/build.log
################################################################################
