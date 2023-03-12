#!/bin/bash -x

#----------------------------------------------------------------------------
# environment
source ${BUILDCONF} || exit 1



#----------------------------------------------------------------------------
# build
list_build_env
download_src https://github.com/libMesh/libmesh/releases/download/v${PKG_VERSION}/libmesh-${PKG_VERSION}.tar.gz

cd ${tmp_build_dir}/${PKG}-${PKG_VERSION} && pwd || exit 1

mkdir ${tmp_build_dir}/${PKG}-build || exit 1
cd ${tmp_build_dir}/${PKG}-build && pwd || exit 1

# Note: --disable-dap is a netcdf option, prevent linking with -lcurl and all its cruft
${tmp_build_dir}/${PKG}-${PKG_VERSION}/configure \
    --prefix=${inst_dir} \
    --enable-static --disable-shared \
    --disable-dependency-tracking \
    --with-cxx=$(which mpicxx) \
    --with-cc=$(which mpicc) \
    --with-f77=$(which mpif77) \
    --with-fc=$(which mpif90) \
    --disable-strict-lgpl \
    --with-thread-model=pthread \
    --enable-blocked-storage \
    --with-methods=opt \
    --enable-unique-id \
    --enable-tecio \
    --disable-glpk \
    --enable-hdf5 --with-hdf5=${HDF5_ROOT} \
    --enable-petsc-required \
    PETSC_DIR=${PETSC_DIR} \
    LIBS="-L${ZLIB_ROOT}/lib -lz" \
    --disable-dap \
    || exit 1

make ${MAKE_J_L} && make install || exit 1

# couple easy checks
make ${MAKE_J_L} -C contrib check
make ${MAKE_J_L} -C examples/introduction/introduction_ex4 check

# save config.log for future repeatabilty / debugging
[ -f config.log ] && cp config.log ${inst_dir}

#----------------------------------------------------------------------------
# libmesh-specific: when building static, many bloated apps end up in ./bin.
# clean up...
cd ${inst_dir}/bin && mv meshtool-opt meshtool && rm -f ./*-opt || exit 1



#----------------------------------------------------------------------------
# config script
cd ${inst_dir} || exit 1

cat <<EOF > config_env.sh
export LIBMESH_VERSION=${PKG_VERSION}
export LIBMESH_ROOT=${inst_dir}

export LD_LIBRARY_PATH=${inst_dir}/lib:\${LD_LIBRARY_PATH}

PATH=${inst_dir}/bin:\${PATH}

EOF

# test it
. ${inst_dir}/config_env.sh || exit 1



#----------------------------------------------------------------------------
# end clean
clean_build_tmp_dirs

echo && echo && echo "SUCCESS: \"$0 $@\" at $(date)"
