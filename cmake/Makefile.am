if CMAKE_BUILD

################################################################################
PKG = cmake
PKG_VERSION = $(CMAKE_VERSION)
PKG_BUILD_DEPS = $(top_builddir)/gcc/$(GCC_VERSION)/config_env.sh

include $(top_srcdir)/rules/Make.pkg_deps

# Things that depend on the compiler only:
BUILT_SOURCES = $(PKG_VERSION)-$(COMPILER_ID)/build.log
################################################################################

endif
