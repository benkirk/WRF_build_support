#----------------------------------------------------------------------------
# Preferred Versions for this build
export GCC_VERSION="10.4.0"       # checked versions 5.5.0 -> 11.3.0.  11.3 requires newer linkers and can be a problem on CentOS
export ZLIB_VERSION="1.2.13"
export CMAKE_VERSION="3.25.3"
export HDF5_VERSION="1.10.6"
export MPICH_VERSION="3.4.3"
export OPENMPI_VERSION="disabled" #"4.1.5"   # checked versions 1.10.4 -> 4.1.4, versions 2x & 3x seem to required shared libs (see openmpi/build.sh)
export PETSC_VERSION="3.16.6"     # checked versions 3.7.7 & 3.16.6
export LIBMESH_VERSION="1.6.2"   # checked versions 1.2.1, 1.4.2, 1.6.2
export TRILINOS_VERSION="13-0-1"
