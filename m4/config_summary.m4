AC_DEFUN([AX_SUMMARIZE_CONFIG],
[
######################################################################################
echo
echo '----------------------------------- SUMMARY -----------------------------------'
echo
echo Package version............... : ${PACKAGE}-${VERSION}
echo
echo Install dir................... : ${prefix}
echo configure..................... : ${0}
echo Build dir..................... : $(pwd)
echo Build user.................... : ${USER}
echo
echo GCC_VERSION................... : ${GCC_VERSION}
echo CMAKE_VERSION................. : ${CMAKE_VERSION}
echo ZLIB_VERSION.................. : ${ZLIB_VERSION}
echo HDF5_VERSION.................. : ${HDF5_VERSION}
echo NETCDF_C_VERSION.............. : ${NETCDF_C_VERSION}
echo NETCDF_FORTRAN_VERSION........ : ${NETCDF_FORTRAN_VERSION}
echo MPICH_VERSION................. : ${MPICH_VERSION}
echo OPENMPI_VERSION............... : ${OPENMPI_VERSION}
######################################################################################
echo
echo '-------------------------------------------------------------------------------'
echo
echo Configure complete, now type \'make\' and then \'make install\'.
echo
######################################################################################
])
