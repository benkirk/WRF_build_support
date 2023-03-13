AC_INIT([libmesh_build_support], [0.0.1], [benkirk@ucar.edu])

AC_MSG_RESULT([-----------------------------------------------------])
AC_MSG_RESULT([-------- Configuring libmesh_build_support ----------])
AC_MSG_RESULT([-----------------------------------------------------])

AC_CONFIG_SRCDIR([configure.ac])
AC_CHECK_FILE([configure.ac], [vpath_build=no], [vpath_build=yes])

#top_srcdir=$(dirname $0)
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])

# # Print configuration info to the header file
# AC_DEFINE_UNQUOTED(CONFIGURE_INFO, ["$0 $ac_configure_args"], [Configuration information.])
#
AM_INIT_AUTOMAKE([dist-bzip2 tar-pax subdir-objects color-tests foreign])
AM_SILENT_RULES(yes)

AM_CONDITIONAL(VPATH_BUILD, test x${vpath_build} = xyes)

AC_PROG_EGREP
AC_PROG_MKDIR_P
AC_PROG_LN_S
AC_PATH_PROGS(TAR, [tar gtar])
AC_PATH_PROGS(CURL, [curl])
AC_PATH_PROGS(WGET, [wget])
AC_PATH_PROGS(GIT, [git])
AC_PATH_PROGS(PYTHON, [python python2 python3])

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

AM_CONDITIONAL([MPICH_BUILD], [test x"${MPICH_VERSION}" != xdisabled])
AM_CONDITIONAL([OPENMPI_BUILD], [test x"${OPENMPI_VERSION}" != xdisabled])

AC_SUBST([COMPILER_ID_STRING])
AC_SUBST([MPI_FAMILY])
AC_SUBST([MPI_VERSION])
AC_SUBST([MPI_ID_STRING])



#----------------------------------------------------------------------------
# output
AC_CONFIG_FILES([
  Makefile
  utils/Makefile
  gcc/Makefile
  cmake/Makefile
  zlib/Makefile
  hdf5/Makefile
  mpich/Makefile
  openmpi/Makefile
  petsc/Makefile
  libmesh/Makefile
  trilinos/Makefile
  build_config.sh
])


AC_OUTPUT
AC_MSG_RESULT([-----------------------------------------------------])
AC_MSG_RESULT([------ Done Configuring libmesh_build_support -------])
AC_MSG_RESULT([-----------------------------------------------------])

AX_SUMMARIZE_CONFIG
