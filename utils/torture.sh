#!/bin/bash -x

[ "x${BUILDCONF}" != "x" ] \
    && [ -f ${BUILDCONF} ] \
    && echo "BUILDCONF = ${BUILDCONF}"  \
    && source ${BUILDCONF}

#----------------------------------------------------------------------------
# paths
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

top_builddir=$( pwd )
top_srcdir=$( cd ${SCRIPTDIR}/.. && pwd )


echo "SCRIPTDIR = ${SCRIPTDIR}"
echo "top_builddir = ${top_builddir}"
echo "top_srcdir = ${top_srcdir}"

#----------------------------------------------------------------------------
# bootstrap
cd ${top_srcdir} && pwd && ./autogen.sh || exit 1

[ -f ${SCRIPTDIR}/autotools/config_env.sh ] && source ${SCRIPTDIR}/autotools/config_env.sh

which autoconf
which automake


#----------------------------------------------------------------------------
# configure
cd ${top_builddir} && pwd || exit 1
${top_srcdir}/configure --prefix=$(pwd)/DISTDIR || exit 1

#----------------------------------------------------------------------------
# configure
make V=1 || exit 1

make distcheck || exit 1
