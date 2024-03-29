#!/bin/bash -x

#----------------------------------------------------------------------------
# environment
source ${BUILDCONF} || exit 1



#----------------------------------------------------------------------------
# build
list_build_env


download_src https://github.com/Unidata/${PKG}/archive/v${NETCDF_C_VERSION}.tar.gz

cd ${tmp_build_dir}/${PKG}-${PKG_VERSION} && pwd || exit 1

mkdir ${tmp_build_dir}/${PKG}-build || exit 1
cd ${tmp_build_dir}/${PKG}-build && pwd || exit 1

${tmp_build_dir}/${PKG}-${PKG_VERSION}/configure \
    --prefix=${inst_dir} \
    --enable-static --enable-shared \
    --disable-libxml2 \
    --disable-dap \
    --disable-byterange \
    LIBS="-L${ZLIB_ROOT}/lib -lz" \
    LDFLAGS="-L${HDF5_ROOT}/lib" \
    CPPFLAGS="-I${HDF5_ROOT}/include" \
    || exit 1

make ${MAKE_J_L} && make install-strip || exit 1

# save config.log for future repeatabilty / debugging
[ -f config.log ] && cp config.log ${inst_dir}/config.log



#----------------------------------------------------------------------------
# config script
cd ${inst_dir} || exit 1

cat <<EOF > config_env.sh
export NETCDF_C_VERSION=${PKG_VERSION}
export NETCDF_C_ROOT=${inst_dir}

export LD_LIBRARY_PATH=${inst_dir}/lib:\${LD_LIBRARY_PATH}

PATH=${inst_dir}/bin:\${PATH}

EOF

# test it
. ${inst_dir}/config_env.sh || exit 1



#----------------------------------------------------------------------------
# end clean
clean_build_tmp_dirs

echo && echo && echo "SUCCESS: \"$0 $@\" at $(date)"
