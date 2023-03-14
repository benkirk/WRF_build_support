#!/bin/bash -x

#----------------------------------------------------------------------------
# environment
source ${BUILDCONF} || exit 1



#----------------------------------------------------------------------------
# build
list_build_env
download_src https://github.com/trilinos/Trilinos/archive/refs/tags/trilinos-release-${PKG_VERSION}.tar.gz || exit 1

cd ${tmp_build_dir}/Trilinos-trilinos-release-${PKG_VERSION} && pwd && pkg_src_dir=$(pwd) || exit 1

mkdir -p ${tmp_build_dir}/build && cd ${tmp_build_dir}/build && pwd || exit 1


# BLAS/LAPACK:
# if we build PETSc first, we can use its from-source compiled BLAS/LAPACK if it exists...
[ "x${PETSC_DIR}" != "x" ] && [ -f ${PETSC_DIR}/lib/libfblas.a ] && blas="${PETSC_DIR}/lib/libfblas.a"
[ "x${PETSC_DIR}" != "x" ] && [ -f ${PETSC_DIR}/lib/libflapack.a ] && lapack="${PETSC_DIR}/lib/libflapack.a"
# if we have a static blas/lapack on the host, use it
[ -f /lib64/libblas.a ] && blas="/lib64/libblas.a"
[ -f /lib64/liblapack.a ] && lapack="/lib64/liblapack.a"

cmake \
    -DCMAKE_INSTALL_PREFIX=${inst_dir}\
    -DTPL_ENABLE_MPI=ON \
    -DTrilinos_ENABLE_Sacado=ON \
    -DTrilinos_ENABLE_Pliris=ON \
    -DTrilinos_ENABLE_Kokkos=OFF \
    -DBUILD_SHARED_LIBS=OFF \
    -DTPL_ENABLE_DLlib=OFF \
    -DTPL_ENABLE_BLAS=ON -DTPL_BLAS_LIBRARIES=${blas} \
    -DTPL_ENABLE_LAPACK=ON -DTPL_LAPACK_LIBRARIES=${lapack} \
    ${pkg_src_dir} \
    || exit 1

make ${MAKE_J_L} && make install || exit 1



#----------------------------------------------------------------------------
# config script
cd ${inst_dir} || exit 1

cat <<EOF > config_env.sh
export TRILINOS_VERSION=${PKG_VERSION}
export TRILINOS_ROOT=${inst_dir}

export LD_LIBRARY_PATH=${inst_dir}/lib:\${LD_LIBRARY_PATH}

EOF


# test it
. ${inst_dir}/config_env.sh || exit 1



#----------------------------------------------------------------------------
# end clean
clean_build_tmp_dirs

echo && echo && echo "SUCCESS: \"$0 $@\" at $(date)"
