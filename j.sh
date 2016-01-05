#!/usr/bin/bash

# A small tool to quickly jump between directories

JFILE=~/.jfile

declare -A J
source $JFILE

function j(){

  case "$1" in
    # add directory entry
    -a)
        J[$2]=`pwd`
        ;;

    # delete directory entry
    -d)
        unset J[$2]
        ;;

    # list all entries
    -l)
        for jk in "${!J[@]}"; do
          echo "J[\"${jk}\"]=\"${J[$jk]}\""
        done
        ;;

    # persist changes
    -s)
        echo "" > $JFILE
        for jk in "${!J[@]}"; do
          echo "J[\"${jk}\"]=\"${J[$jk]}\"" >> $JFILE
        done
        ;;

    # reload entries
    -r)
        source $JFILE
        ;;

    # by default jump
    *)
        cd "${J[$1]}"
        ;;
  esac
}

