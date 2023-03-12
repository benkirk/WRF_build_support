#!/bin/bash -x

#----------------------------------------------------------------------------
# environment
source ${BUILDCONF} || exit 1



#----------------------------------------------------------------------------
# build
list_build_env

# dowload paths look like https://github.com/Kitware/CMake/releases/download/v3.24.3/cmake-3.24.3.tar.gz
download_src https://github.com/Kitware/CMake/releases/download/v${PKG_VERSION}/cmake-${PKG_VERSION}.tar.gz

cd ${tmp_build_dir}/${PKG}-${PKG_VERSION} && pwd || exit 1

mkdir ${tmp_build_dir}/${PKG}-build || exit 1
cd ${tmp_build_dir}/${PKG}-build && pwd || exit 1

${tmp_build_dir}/${PKG}-${PKG_VERSION}/configure \
                --prefix=${inst_dir} \
                --generator="Unix Makefiles" \
                --no-qt-gui \
    || exit 1

make ${MAKE_J_L} && make install || exit 1



#----------------------------------------------------------------------------
# config script
cd ${inst_dir} || exit 1

cat <<EOF > config_env.sh
export CMAKE_VERSION=${PKG_VERSION}

export PATH=${inst_dir}/bin:\${PATH}

EOF

# test it
. ${inst_dir}/config_env.sh || exit 1



#----------------------------------------------------------------------------
# end clean
clean_build_tmp_dirs

echo && echo && echo "SUCCESS: \"$0 $@\" at $(date)"
