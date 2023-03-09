# clear all modules
# this should be a no-op on systems without a 'module' command
type module >/dev/null 2>&1 \
    && module --force purge > /dev/null 2>&1

#----------------------------------------------------------------------------
# Paths
top_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

build_stage=

# potential paths for temporary building; use first one that is writeable
for try_path in "/local/tmp-${USER}" "/tmp/tmp-${USER}"; do
    mkdir -p ${try_path} >/dev/null 2>&1 \
        && [ -w ${try_path} ] \
        && build_stage=${try_path} \
        && break
done

tmp_build_dir="${build_stage}${SCRIPTDIR}/tmp_builddir"

echo "top_dir=${top_dir}"
echo "tmp_build_dir=${tmp_build_dir}"


#----------------------------------------------------------------------------
# Build processes
type nproc >/dev/null 2>&1 && MAKE_J_PROCS=$(nproc)
MAKE_J_PROCS="${MAKE_J_PROCS:-6}"
