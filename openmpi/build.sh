#!/bin/bash -x

#----------------------------------------------------------------------------
# environment
source ${BUILDCONF} || exit 1



#----------------------------------------------------------------------------
# build
list_build_env

# download URLs look like this, handle accordingly: https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.5.tar.gz
download_src https://download.open-mpi.org/release/open-mpi/v${PKG_VERSION%.*}/openmpi-${PKG_VERSION}.tar.gz

cd ${tmp_build_dir}/openmpi-${PKG_VERSION} && pwd || exit 1

mkdir ${tmp_build_dir}/openmpi-build || exit 1
cd ${tmp_build_dir}/openmpi-build && pwd || exit 1

case ${PKG_VERSION} in
    4.*|3.*|2.*)
        unset F77
        ${tmp_build_dir}/openmpi-${PKG_VERSION}/configure \
                        CXX=${CXX} CC=${CC} FC=${FC} F77= \
                        --prefix=${inst_dir} \
                        --with-pmix=internal \
                        --with-hwloc=internal \
                        --enable-static --disable-shared \
                        --disable-dependency-tracking \
            || exit 1
        ;;

    3.*|2.*)
        unset F77
        ${tmp_build_dir}/openmpi-${PKG_VERSION}/configure \
                        CXX=${CXX} CC=${CC} FC=${FC} F77= \
                        --prefix=${inst_dir} \
                        --with-pmix=internal \
                        --with-hwloc=internal \
                        --enable-static --enable-shared \
                        --disable-dependency-tracking \
            || exit 1
        ;;

    1.*)
        unset F77
        ${tmp_build_dir}/openmpi-${PKG_VERSION}/configure \
                        CXX=${CXX} CC=${CC} FC=${FC} F77=${F77} \
                        --prefix=${inst_dir} \
                        --with-hwloc=internal \
                        --enable-static --disable-shared \
                        --disable-dependency-tracking \
            || exit 1
        ;;
    *)
        echo "I don't know how to configure ${PKG_VERSION}"
        exit 1
        ;;
esac

make -j ${MAKE_J_PROCS} && make install || exit 1

# save config.log for future repeatabilty / debugging
[ -f config.log ] && cp config.log ${inst_dir}



#----------------------------------------------------------------------------
# config script
cd ${inst_dir} || exit 1

cat <<EOF > config_env.sh
export OPENMPI_VERSION=${PKG_VERSION}
export OPENMPI_ROOT=${inst_dir}
export MPI_ID_STRING=openmpi-${PKG_VERSION}

export LD_LIBRARY_PATH=${inst_dir}/lib:\${LD_LIBRARY_PATH}

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
