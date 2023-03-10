#!/bin/bash -x

#----------------------------------------------------------------------------
# environment
source ${BUILDCONF} || exit 1



#----------------------------------------------------------------------------
# build
curl -SL https://ftpmirror.gnu.org/gnu/gcc/gcc-${PKG_VERSION}/gcc-${PKG_VERSION}.tar.gz | tar zx || exit 1

cd ${tmp_build_dir}/gcc-${PKG_VERSION} && pwd || exit 1
./contrib/download_prerequisites || exit 1

mkdir ${tmp_build_dir}/gcc-build || exit 1
cd ${tmp_build_dir}/gcc-build && pwd || exit 1

${tmp_build_dir}/gcc-${PKG_VERSION}/configure \
                --prefix=${inst_dir} \
                --enable-static --disable-shared \
                --enable-languages=c,c++,fortran \
                --disable-multilib \
                --disable-bootstrap \
    || exit 1

make -j ${MAKE_J_PROCS} && make install-strip || exit 1

# save config.log for future repeatabilty / debugging
[ -f config.log ] && cp config.log ${inst_dir}



#----------------------------------------------------------------------------
# config script
cd ${inst_dir} || exit 1

cat <<EOF > config_env.sh
export GCC_VERSION=${PKG_VERSION}
export GCC_ROOT=${inst_dir}
export COMPILER_ID_STRING=gcc-${PKG_VERSION}

export LD_LIBRARY_PATH=${inst_dir}/lib64:${inst_dir}/lib:\${LD_LIBRARY_PATH}

PATH=${inst_dir}/bin:\${PATH}

export CXX=${inst_dir}/bin/g++
export CC=${inst_dir}/bin/gcc
export FC=${inst_dir}/bin/gfortran
export F77=${inst_dir}/bin/gfortran

EOF


#----------------------------------------------------------------------------
# end clean
rm -rf ${tmp_build_dir}

. ${inst_dir}/config_env.sh && echo && echo && echo "SUCCESS: \"$0 $@\" at $(date)"
