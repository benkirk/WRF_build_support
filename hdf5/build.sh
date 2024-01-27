#!/bin/bash -x

#----------------------------------------------------------------------------
# environment
source ${BUILDCONF} || exit 1



#----------------------------------------------------------------------------
# build
#list_build_env

# URLS of the format https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.6/src/hdf5-1.10.6.tar.gz
download_src https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${PKG_VERSION%.*}/hdf5-${PKG_VERSION}/src/hdf5-${PKG_VERSION}.tar.gz

cd ${tmp_build_dir}/${PKG}-${PKG_VERSION} && pwd || exit 1

mkdir ${tmp_build_dir}/${PKG}-build || exit 1
cd ${tmp_build_dir}/${PKG}-build && pwd || exit 1

${tmp_build_dir}/${PKG}-${PKG_VERSION}/configure \
    --prefix=${inst_dir} \
    --disable-static --enable-shared \
    --enable-hl --disable-cxx --enable-fortran \
    --disable-parallel \
    --disable-dependency-tracking \
    --with-szlib=no \
    LIBS="-L${ZLIB_ROOT}/lib -lz" \
    || exit 1

make ${MAKE_J_L} && make install-strip || exit 1

# save config.log for future repeatabilty / debugging
[ -f config.log ] && cp config.log ${inst_dir}



#----------------------------------------------------------------------------
# config script
cd ${inst_dir} || exit 1

cat <<EOF > config_env.sh
export HDF5_VERSION=${PKG_VERSION}
export HDF5_ROOT=${inst_dir}

export LD_LIBRARY_PATH=${inst_dir}/lib:\${LD_LIBRARY_PATH}

PATH=${inst_dir}/bin:\${PATH}

EOF

# test it
. ${inst_dir}/config_env.sh || exit 1



#----------------------------------------------------------------------------
# end clean
clean_build_tmp_dirs

echo && echo && echo "SUCCESS: \"$0 $@\" at $(date)"
