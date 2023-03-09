#!/bin/bash

[ -f ./utils/autotools/config_env.sh ] && source ./utils/autotools/config_env.sh

#########################################################################################
function check_autotool_prerequisites ()
{
    # prerequisite versions
    automake_major=1
    automake_minor=16

    autoconf_major=2
    autoconf_minor=69

    build_autotools=0


    autoreconf=`which autoreconf 2>/dev/null`
    if (test "x${autoreconf}" != "x"); then
        if (test -x ${autoreconf}); then
            autoconf_version=`${autoreconf} --version | grep " ${autoconf_major}\." | cut -d"." -f2`
            if (test ${autoconf_version} -lt ${autoconf_minor}); then
                echo "Autoconf Version ${autoconf_major}.${autoconf_version} too old, building a new one..."
                build_autotools=1
            else
                version_id=`${autoreconf} --version 2>&1 | grep "(GNU Autoconf)"`
                #echo "Using autoconf (${version_id})"
            fi
        else
            build_autotools=1
        fi
    else
        build_autotools=1
    fi


    libtool=`which glibtool 2>/dev/null`
    if (test "x$libtool" = "x"); then
        libtool=`which libtool 2>/dev/null`
    fi
    if (test "x$libtool" != "x"); then
        if (test -x $libtool); then
            libtool_version=`$libtool --version 2>&1 | grep "(GNU libtool)"`

            case "$libtool_version" in
                *2.4* | *2.2*)
                    echo "Using libtool ($libtool_version)"
                    ;;
                *)
                    echo "Indaequate Libtool ($libtool_version), building a new one..."
                    build_autotools=1
            esac
        else
            build_autotools=1
        fi
    else
        build_autotools=1
    fi


    automake=`which automake 2>/dev/null`
    if (test "x$automake" != "x"); then
        if (test -x $automake); then
            automake_version=`$automake --version | grep " $automake_major\." | cut -d"." -f2`
            if (test $automake_version -lt $automake_minor); then
                echo "Automake Version $automake_major.$automake_version too old, building a new one..."
                build_autotools=1
            else
                version_id=`$automake --version 2>&1 | grep "(GNU automake)"`
                echo "Using automake ($version_id)"
            fi
        else
            build_autotools=1
        fi
    else
        build_autotools=1
    fi

    return $build_autotools
}
#########################################################################################



check_autotool_prerequisites
build_autotools=$?

#########################################################################################
for arg in $@; do
    if (test "x$arg" = "x--build-autotools"); then
        echo "building autotools at user request"
        build_autotools=1
    fi
done

# install if missing, inadequate, or requested
if [ 1 -eq ${build_autotools} ]; then
  ./utils/build_autotools.sh \
      && source ./utils/autotools/config_env.sh \
      || exit 1
fi



autoreconf -iv --force || exit 1
