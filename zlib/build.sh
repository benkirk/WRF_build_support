#!/bin/bash -x

#----------------------------------------------------------------------------
# environment
source ${BUILDCONF} || exit 1



#----------------------------------------------------------------------------
# build
download_src https://github.com/madler/zlib/releases/download/v${PKG_VERSION}/zlib-${PKG_VERSION}.tar.gz


cd ${tmp_build_dir}/zlib-${PKG_VERSION} && pwd|| exit 1

./configure \
    --prefix=${inst_dir} \
    || exit 1

make ${MAKE_J_L}  && make install || exit 1



#----------------------------------------------------------------------------
# config script
cd ${inst_dir} || exit 1

cat <<EOF > config_env.sh
export ZLIB_VERSION=${PKG_VERSION}
export ZLIB_ROOT=${inst_dir}

export LD_LIBRARY_PATH=${inst_dir}/lib:\${LD_LIBRARY_PATH}

EOF

# test it
. ${inst_dir}/config_env.sh || exit 1



#----------------------------------------------------------------------------
# end clean
clean_build_tmp_dirs

echo && echo && echo "SUCCESS: \"$0 $@\" at $(date)"
