#!/usr/bin/bash

# A small tool to quickly jump between directories

JFILE=~/.jfile

declare -A J

if [ -x $JFILE ]; then
    source $JFILE
fi

function j(){

  case "$1" in

    # help
    -h|--help)
        echo "j -h|--help               show help"
        echo "j -a <name>               add new entry for pwd with key <name>"
        echo "j -d <name>               delete entry for key <name>"
        echo "j -l                      list all entries"
        echo "j -r                      reload all entries"
        echo "j -s                      save all entries to $JFILE"
        echo "j <name>                  jump to directory with key <name>"
        ;;

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

    # reload entries
    -r)
        if [ -x $JFILE ]; then
            source $JFILE
        fi
        ;;

    # persist changes
    -s)
        echo "" > $JFILE
        for jk in "${!J[@]}"; do
          echo "J[\"${jk}\"]=\"${J[$jk]}\"" >> $JFILE
        done
        ;;

    # by default jump
    *)
        cd "${J[$1]}"
        ;;
  esac
}

