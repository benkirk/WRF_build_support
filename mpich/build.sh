#!/bin/bash -x

#----------------------------------------------------------------------------
# environment
source ${BUILDCONF} || exit 1



#----------------------------------------------------------------------------
# build
#list_build_env

download_src https://www.mpich.org/static/downloads/${PKG_VERSION}/${PKG}-${PKG_VERSION}.tar.gz

cd ${tmp_build_dir}/${PKG}-${PKG_VERSION} || exit 1

mkdir ${tmp_build_dir}/mpich-build || exit 1
cd ${tmp_build_dir}/mpich-build && pwd || exit 1

# from gcc-10.4:
# checking whether /tmp/char_build_support/gcc/10.4.0/bin/gfortran allows mismatched arguments... yes, with -fallow-argument-mismatch
# configure: error: The Fortran compiler /tmp/char_build_support/gcc/10.4.0/bin/gfortran does not accept programs that call the same routine with arguments of different types without the option -fallow-argument-mismatch.  Rerun configure with FFLAGS=-fallow-argument-mismatch
#    FFLAGS=-fallow-argument-mismatch \
FFLAGS=
case "${COMPILER_ID_STRING}" in
    gcc-1*) # gcc-10+
        FFLAGS="-fallow-argument-mismatch"; ;;
    *)
        FFLAGS= ; ;;
esac

${tmp_build_dir}/${PKG}-${PKG_VERSION}/configure \
                CXX=${CXX} CC=${CC} FC=${FC} F77=${F77} \
                FFLAGS=${FFLAGS} \
                --prefix=${inst_dir} \
                --disable-dependency-tracking \
                --with-wrapper-dl-type=none \
                --with-device=ch4:ofi \
                --enable-fortran
                --with-mpl-prefix=embedded \
                --with-zm-prefix=embedded \
                --with-yaksa-prefix=embedded \
                --with-hwloc-prefix=embedded \
                --disable-static --enable-shared \
                --disable-libxml2 \
                --disable-libudev \
    || exit 1

make ${MAKE_J_L} && make install || exit 1

# save config.log for future repeatabilty / debugging
[ -f config.log ] && cp config.log ${inst_dir}



#----------------------------------------------------------------------------
# config script
cd ${inst_dir} || exit 1

cat <<EOF > config_env.sh
export MPICH_VERSION=${PKG_VERSION}
export MPICH_ROOT=${inst_dir}
export MPI_ID_STRING=mpich-${PKG_VERSION}

#export LD_LIBRARY_PATH=${inst_dir}/lib:\${LD_LIBRARY_PATH}

PATH=${inst_dir}/bin:\${PATH}

export MPICXX=${inst_dir}/bin/mpicxx
export MPICC=${inst_dir}/bin/mpicc
export MPIFC=${inst_dir}/bin/mpif90
export MPIF77=${inst_dir}/bin/mpif77

export CXX=\${MPICXX}
export CC=\${MPICC}
export FC=\${MPIFC}
export F77=\${MPIF77}

EOF

# test it
. ${inst_dir}/config_env.sh || exit 1



#----------------------------------------------------------------------------
# end clean
clean_build_tmp_dirs

echo && echo && echo "SUCCESS: \"$0 $@\" at $(date)"
