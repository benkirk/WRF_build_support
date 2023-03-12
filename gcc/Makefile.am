################################################################################
PKG = gcc
PKG_VERSION = $(GCC_VERSION)
################################################################################


################################################################################
BUILT_SOURCES = $(PKG_VERSION)/build.log

noinst_SCRIPTS = build.sh

$(PKG_VERSION)/build.log: build.sh
	$(AM_V_GEN)if $(AM_V_P); then set -x; else echo "  GEN -->  Building ${PKG}-${PKG_VERSION} from source, patience ..."; fi; \
	  BUILDCONF="$(abs_top_builddir)/build_config.sh" \
	  PKG="$(PKG)" \
	  PKG_VERSION="$(PKG_VERSION)" \
	  PKG_INSTALL_PREFIX="$(abs_builddir)/$(@D)" \
	  $(<) > build.out 2>&1  || { rm -rf $(@D); exit 1; }
	$(AM_V_at)mv build.out $(@)
	$(AM_V_at)echo "  GEN -->  $(<): Done at $$(date)"
