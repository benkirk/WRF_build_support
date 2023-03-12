AC_INIT([libmesh_build_support], [0.0.1], [benkirk@ucar.edu])

AC_MSG_RESULT([-----------------------------------------------------])
AC_MSG_RESULT([-------- Configuring libmesh_build_support ----------])
AC_MSG_RESULT([-----------------------------------------------------])

AC_CONFIG_SRCDIR([configure.ac])


#top_srcdir=$(dirname $0)
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])

# # Print configuration info to the header file
# AC_DEFINE_UNQUOTED(CONFIGURE_INFO, ["$0 $ac_configure_args"], [Configuration information.])
#
AM_INIT_AUTOMAKE([dist-bzip2 tar-pax subdir-objects color-tests 1.16 foreign])
AM_SILENT_RULES(yes) dnl # use silent rules - automake 1.16

AC_PROG_EGREP
AC_PROG_MKDIR_P
AC_PROG_LN_S
AC_PATH_PROGS(TAR, [tar gtar])
AC_PATH_PROGS(CURL, [curl])
AC_PATH_PROGS(WGET, [wget])
AC_PATH_PROGS(GIT, [git])
AC_PATH_PROGS(PYTHON, [python python2])

# "Precious" environment variables to control the build environment
AC_ARG_VAR([GCC_VERSION], [requested GCC version. e.g. "10.4.0"])
AC_ARG_VAR([ZLIB_VERSION], [requested Zlib version. e.g. "1.2.13"])
AC_ARG_VAR([CMAKE_VERSION], [requested CMake version. e.g. "3.25.3"])
AC_ARG_VAR([HDF5_VERSION], [requested HDF5 version. e.g. "1.10.6"])
AC_ARG_VAR([MPICH_VERSION], [requested MPICH version. e.g. "3.4.3" (or "disabled")])
AC_ARG_VAR([OPENMPI_VERSION], [requested OPENMPI version. e.g. "4.1.4" (or "disabled")])
AC_ARG_VAR([PETSC_VERSION], [requested PETSC version. e.g. "3.16.6" (or "disabled")])
AC_ARG_VAR([LIBMESH_VERSION], [requested LIBMESH version. e.g. "4.1.4" (or "disabled")])
AC_ARG_VAR([TRILINOS_VERSION], [requested TRILINOS version. e.g. "13-0-1" (or "disabled")])

#----------------------------------------------------------------------------
# Preferred Default Versions (set-if-unset approach)
GCC_VERSION="${GCC_VERSION:-9.5.0}"
ZLIB_VERSION="${ZLIB_VERSION:-1.2.13}"
CMAKE_VERSION="${CMAKE_VERSION:-3.25.3}"
HDF5_VERSION="${HDF5_VERSION:-1.10.6}"
MPICH_VERSION="${MPICH_VERSION:-3.4.3}"
OPENMPI_VERSION="${OPENMPI_VERSION:-4.1.4}"
PETSC_VERSION="${PETSC_VERSION:-3.7.7}"
LIBMESH_VERSION="${LIBMESH_VERSION:-1.6.2}"
TRILINOS_VERSION="${TRILINOS_VERSION:-13-0-1}"

COMPILER_ID_STRING="gcc-${GCC_VERSION}"

# note the last not "disabled" of these AS_IFs will be the preferred MPI
MPI_FAMILY=""
AS_IF([test "x${OPENMPI_VERSION}" != xdisabled], [MPI_ID_STRING="openmpi-${OPENMPI_VERSION}"; MPI_FAMILY="openmpi"; MPI_VERSION="${OPENMPI_VERSION}"])
AS_IF([test "x${MPICH_VERSION}"   != xdisabled], [MPI_ID_STRING="mpich-${MPICH_VERSION}";     MPI_FAMILY="mpich";   MPI_VERSION="${MPICH_VERSION}"])

AC_SUBST([COMPILER_ID_STRING])
AC_SUBST([MPI_FAMILY])
AC_SUBST([MPI_VERSION])
AC_SUBST([MPI_ID_STRING])

#
# # Checks for programs.
# AC_PROG_CXX
# AC_PROG_CC
#
# AC_PROG_FC
# AC_FC_LIBRARY_LDFLAGS
# AC_FC_WRAPPERS
#
# AM_PROG_CC_C_O # mpl_examples/Makefile.am:74: warning: compiling ... in subdir requires 'AM_PROG_CC_C_O'
#
# AC_LANG([C])
#
# #-----------------------------------------------------
# # Initialize libtool.  By default, we will build
# # only shared libraries on platforms that support them
# #-----------------------------------------------------
# LT_INIT([disable-static])
#
# AC_CONFIG_HEADERS([config.h])
# AC_CHECK_HEADERS_ONCE([sys/types.h stdio.h stdlib.h time.h string.h unistd.h sys/resource.h stdatomic.h dlfcn.h])
#
# AC_PATH_PROG([PKG_CONFIG], [pkg-config], [no])
#
# # pthreads & thread-local storage
# AX_PTHREAD
# AX_TLS
#
# # options
# AC_ARG_ENABLE(fortran,
#               [  --enable-fortran     Build Fortran API.],
#               [enable_fortran=$enableval],
#               [enable_fortran="yes"])
# if test "x$enable_fortran" = "xyes"; then
#     AC_DEFINE([ENABLE_FORTRAN], [1], [Build Fortran API.])
#     AC_MSG_RESULT([<<< Enabling Fortran API >>>])
# fi
#
#
#
# AC_OPENMP
# openmp_ok=no
# enable_openmp=no
# if test "x$ac_cv_prog_c_openmp" != "xunsupported" && test "x$ac_cv_prog_c_openmp" != "x"; then
#   openmp_ok=yes
#   enable_openmp=yes
#   AC_MSG_RESULT([<<< OpenMP-capable compiler detected. >>>])
#   AC_DEFINE([ENABLE_OPENMP], [1], [Include OpenMP interface.])
# fi
# AM_CONDITIONAL([OPENMP_BUILD], [test x"$enable_openmp" = xyes])
#
#
#
# AC_ARG_ENABLE(nvml,
#               [  --enable-nvml           Include Nvidia NVML interface.],
#               [enable_nvml=$enableval],
#               [enable_nvml="yes"])
# if test "x$enable_nvml" = "xyes"; then
#   AC_PATH_PROG([NVIDIA_SMI], [nvidia-smi])
#   AC_CHECK_LIB([dl], [dlopen], [], [enable_nvml=no])
#   #AC_CHECK_LIB([nvidia-ml], [nvmlInit], [], [enable_nvml=no])
#   if test "x$enable_nvml" = "xyes"; then
#     AC_CHECK_HEADER([nvml.h], [nvml_label="(using external nvml.h)"; found_nvml_h=yes], [found_nvml_h=no])
#     # If the library works, but we can't find the header, fall back to our
#     # ./contrib version
#     if test "x$found_nvml_h" = "xno"; then
#       unset ac_cv_header_nvml_h nvml_label
#       CPPFLAGS="${CPPFLAGS} -I${top_srcdir}/contrib/nvml/include"
#       AC_CHECK_HEADER([nvml.h], [nvml_label="(using nvml.h from ./contrib)"; internal_nvml_h=yes], [enable_nvml=no])
#     fi
#   fi
#   if test "x$enable_nvml" = "xyes"; then
#     AC_DEFINE([ENABLE_NVML], [1], [Build with NVML GPU support])
#     AC_MSG_RESULT([<<< Enabling Nvidia NVML GPU support ${nvml_label}. >>>])
#   fi
# fi
# AM_CONDITIONAL([NVML_BUILD], [test x"$enable_nvml" = xyes])
#
#
#
# AC_ARG_ENABLE(mpi,
#               [  --enable-mpi            Include MPI interface.],
#               [enable_mpi=$enableval],
#               [enable_mpi="yes"])
# if test "x$enable_mpi" = "xyes"; then
#   AC_LANG_PUSH([C++])
#   AX_MPI([found_mpicxx=yes], [found_mpicxx=no])
#   AC_LANG_POP([C++])
#   AX_MPI([found_mpi=yes], [found_mpi=no; enable_mpi=no])
#   if test "x$found_mpi" = "xyes"; then
#     AC_CHECK_PROGS([MPIEXEC], [mpiexec mpiexec_mpt mpirun], [mpiexec])
#     AC_DEFINE([ENABLE_MPI], [1], [Build with MPI support (really only used for test suite)])
#     AC_MSG_RESULT([<<< Enabling MPI support (used in test suite only). >>>])
#     #CC="$MPICC"
#   fi
# fi
# AM_CONDITIONAL([MPI_BUILD], [test x"$enable_mpi" = xyes])
#
#
#
# AC_ARG_ENABLE(doc,
#               [  --enable-doc            Build documentation (requires doxygen).],
#               [enable_doc=$enableval],
#               [enable_doc="no"])
#     if test "x$enable_doc" = "xyes"; then
#       AC_PROG_MKDIR_P
#       AC_PATH_PROG([DOXYGEN], [doxygen], [disable])
#       if test "x$DOXYGEN" = "xdisable"; then
#         enable_doc="no"
#       fi
#     fi
# AM_CONDITIONAL([BUILD_DOCS], [test x"$enable_doc" = xyes])
#
AC_CONFIG_FILES([
  Makefile
  gcc/Makefile
  cmake/Makefile
  zlib/Makefile
  hdf5/Makefile
  mpich/Makefile
  openmpi/Makefile
  petsc/Makefile
  libmesh/Makefile
  build_config.sh
])


AC_OUTPUT
AC_MSG_RESULT([-----------------------------------------------------])
AC_MSG_RESULT([------ Done Configuring libmesh_build_support -------])
AC_MSG_RESULT([-----------------------------------------------------])

# AX_SUMMARIZE_CONFIG
