#!/bin/bash -x

#----------------------------------------------------------------------------
# environment
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
[ -f ${SCRIPTDIR}/build_env.sh ] && . ${SCRIPTDIR}/build_env.sh || \
    { echo "cannot locate ${SCRIPTDIR}/build_env.sh"; exit 1; }



#----------------------------------------------------------------------------
# build
top_dir=${SCRIPTDIR}

inst_dir=${top_dir}/autotools

[ -d ${inst_dir} ] && rm -rf ${inst_dir}

rm -rf ${tmp_build_dir}
mkdir -p ${tmp_build_dir} || exit 1


declare -A versions

versions[m4]=1.4.19
versions[autoconf]=2.71
versions[automake]=1.16.5
versions[libtool]=2.4.6
versions[make]=4.3

# sample URLS:
# https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.gz


# set the path to use the new tools as they are installed.
# for example, the new autoconf is needed to build automake.
PATH=${inst_dir}/bin:$PATH

#for PKG in "${!versions[@]}"; do
for PKG in "m4" "autoconf" "automake" "libtool" "make"; do

    cd ${tmp_build_dir} && pwd || exit 1

    PKG_VERSION=${versions[${PKG}]}
    echo "building ${PKG}-${PKG_VERSION}"

    # poor mans fallback - in case some mirrors fail (they do..)
    for cnt in $(seq 1 10); do
        curl -SL https://ftpmirror.gnu.org/gnu/${PKG}/${PKG}-${PKG_VERSION}.tar.gz | tar zx \
            && break
    done

    cd ${PKG}-${PKG_VERSION} || exit 1
    ./configure \
        --prefix=${inst_dir} \
        || exit 1

    make -j ${MAKE_J_PROCS} && make install || exit 1
done

pwd && ls



#----------------------------------------------------------------------------
# config script
cd ${inst_dir} || exit 1

echo "# created from ${0} on $(date)" > config_env.sh
for PKG in "${!versions[@]}"; do

    PKG_VERSION=${versions[${PKG}]}

    cat <<EOF >> config_env.sh
export ${PKG^^}_VERSION=${PKG_VERSION}
export ${PKG^^}_ROOT=${inst_dir}
EOF
done

cat <<EOF >> config_env.sh

export LD_LIBRARY_PATH=${inst_dir}/lib:\${LD_LIBRARY_PATH}

PATH=${inst_dir}/bin:\${PATH}

EOF


#----------------------------------------------------------------------------
# end clean
rm -rf ${tmp_build_dir}

. ${inst_dir}/config_env.sh && echo && echo && echo "SUCCESS: \"$0 $@\" at $(date)"
