#!/bin/bash -x

#----------------------------------------------------------------------------
# environment
source ${BUILDCONF} || exit 1



#----------------------------------------------------------------------------
# build
list_build_env

download_src https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-${PKG_VERSION}.tar.gz || exit 1

# throw the * on the end so we can download e.g. 3.13 which unpacks to 3.13.6
cd ${tmp_build_dir}/${PKG}-${PKG_VERSION}* && pwd || exit 1

unset CXX CC FC F77 LDFLAGS PETSC_DIR PETSC_ARCH

# BLAS/LAPACK:
blaslapack_option="--download-fblaslapack=1"
[ -f /lib64/libblas.a ] && [ -f /lib64/liblapack.a ] && blaslapack_option="--with-blas-lib=/lib64/libblas.a --with-lapack-lib=/lib64/liblapack.a"

case ${PKG_VERSION} in
    3.7*|3.8*|3.9*)
        # some options that fail: too old to find current sources compatible with older petsc
        # e.g.; Unable to locate commit: v2.14.0 in repository: .../petsc-3.9.4/petsc-3.9.4/arch-linux2-c-opt/externalpackages/git.hypre.
        ${PYTHON} ./configure \
            --with-debugging=0 --with-shared-libraries=0 \
            --with-ssl=0 \
            --with-spooles=1 --download-spooles=yes \
            --with-ml=1 --download-ml=yes \
            --with-suitesparse=1 --download-suitesparse=yes \
            --with-superlu=1 --download-superlu=yes \
            --with-scalapack=1 --download-scalapack=yes \
            ${blaslapack_option} --with-x=0 \
            --prefix=${inst_dir} \
            --with-cc=$(which mpicc) \
            --with-cxx=$(which mpicxx) \
            --with-fc=$(which mpif90) \
            --CFLAGS="-g -O2" \
            --CXXFLAGS="-g -O2" \
            --FFLAGS="-g -O2" \
    || exit 1
        ;;

    # ML does not honor shared libs in PETSc 3.17...
    3.17*)
        ${PYTHON} ./configure \
            --with-debugging=0 --with-shared-libraries=0 \
            --with-ssl=0 \
            --with-szlib=0 \
            --with-spooles=1 --download-spooles=yes \
            --with-ml=0 \
            --with-suitesparse=1 --download-suitesparse=yes \
            --with-superlu=1 --download-superlu=yes \
            --with-scalapack=1 --download-scalapack=yes \
            ${blaslapack_option} --with-x=0 \
            --with-hypre=1 --download-hypre=yes \
            --prefix=${inst_dir} \
            --with-cc=$(which mpicc) \
            --with-cxx=$(which mpicxx) \
            --with-fc=$(which mpif90) \
            --CFLAGS="-g -O2" \
            --CXXFLAGS="-g -O2" \
            --FFLAGS="-g -O2" \
            || exit 1
        ;;

    *)
        ${PYTHON} ./configure \
            --with-debugging=0 --with-shared-libraries=0 \
            --with-ssl=0 \
            --with-szlib=0 \
            --with-spooles=1 --download-spooles=yes \
            --with-ml=1 --download-ml=yes \
            --with-suitesparse=1 --download-suitesparse=yes \
            --with-superlu=1 --download-superlu=yes \
            --with-scalapack=1 --download-scalapack=yes \
            ${blaslapack_option} --with-x=0 \
            --with-hypre=1 --download-hypre=yes \
            --prefix=${inst_dir} \
            --with-cc=$(which mpicc) \
            --with-cxx=$(which mpicxx) \
            --with-fc=$(which mpif90) \
            --CFLAGS="-g -O2" \
            --CXXFLAGS="-g -O2" \
            --FFLAGS="-g -O2" \
            || exit 1
        ;;

esac

make PETSC_DIR=$(pwd) all install || exit 1
#make PETSC_DIR=${inst_dir} PETSC_ARCH="" test || exit 1

# save configure.log for future repeatabilty / debugging
[ -f configure.log ] && cp configure.log ${inst_dir}



#----------------------------------------------------------------------------
# config script
cd ${inst_dir} || exit 1

cat <<EOF > config_env.sh
export PETSC_VERSION=${PKG_VERSION}
export PETSC_DIR=${inst_dir}

export LD_LIBRARY_PATH=${inst_dir}/lib:\${LD_LIBRARY_PATH}

EOF

# test it
. ${inst_dir}/config_env.sh || exit 1



#----------------------------------------------------------------------------
# end clean
clean_build_tmp_dirs

echo && echo && echo "SUCCESS: \"$0 $@\" at $(date)"
