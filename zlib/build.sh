#!/bin/bash -x

#----------------------------------------------------------------------------
# environment
source ${BUILDCONF} || exit 1



#----------------------------------------------------------------------------
# build
# of the format https://zlib.net/zlib-1.2.13.tar.gz
download_src https://zlib.net/zlib-${PKG_VERSION}.tar.gz


cd ${tmp_build_dir}/zlib-${PKG_VERSION} && pwd|| exit 1

./configure \
    --prefix=${inst_dir} \
    --static \
    || exit 1
#                LIBS="-lm -lz" \

make && make install || exit 1



#----------------------------------------------------------------------------
# config script
cd ${inst_dir} || exit 1

cat <<EOF > config_env.sh
export ZLIB_VERSION=${PKG_VERSION}
export ZLIB_ROOT=${inst_dir}

#export LD_LIBRARY_PATH=${inst_dir}/lib:\${LD_LIBRARY_PATH}

EOF


# symlink if we appended an ID string
if [ "x$(basename ${inst_dir})" != "x${PKG_VERSION}" ]; then
    cd ${inst_dir}/.. || exit 1
    rm -f ${PKG_VERSION}
    ln -sf $(basename ${inst_dir}) ${PKG_VERSION}
fi


#----------------------------------------------------------------------------
# end clean
rm -rf ${tmp_build_dir}

. ${inst_dir}/config_env.sh && echo && echo && echo "SUCCESS: \"$0 $@\" at $(date)"
