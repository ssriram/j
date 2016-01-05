#!/usr/bin/bash

# A small tool to quickly jump between directories

JFILE=~/.jfile

declare -A J

if [ -f $JFILE ]; then
    source $JFILE
fi

function j(){

  case "$1" in

    # help
    -h|--help)
        echo "j -h|--help               show help"
        echo "j -a <name>               add new entry for pwd with key <name>"
        echo "j -a <name> <dir>         add new entry for <dir> with key <name>"
        echo "j -d <name>               delete entry for key <name>"
        echo "j -l                      list all entries"
        echo "j -r                      reload all entries"
        echo "j -s                      save all entries to $JFILE"
        echo "j <name>                  jump to directory with key <name>"
        ;;

    # add directory entry
    -a)
        if [ -n "$3" ]; then
            J[$2]="$3"
        elif [ -n "$2" ]; then
            J[$2]=`pwd`
        else
            echo "j -a <name>               add new entry for pwd with key <name>"
            echo "j -a <name> <dir>         add new entry for <dir> with key <name>"
        fi
        ;;

    # delete directory entry
    -d)
        if [ -n "$2" ]; then
            unset J[$2]
        else
            echo "j -d <name>               delete entry for key <name>"
        fi
        ;;

    # list all entries
    -l)
        for jk in "${!J[@]}"; do
          echo "J[\"${jk}\"]=\"${J[$jk]}\""
        done
        ;;

    # reload entries
    -r)
        if [ -f $JFILE ]; then
            source $JFILE
        fi
        ;;

    # persist changes
    -s)
        if [ -f $JFILE ]; then
            rm $JFILE
        fi
        for jk in "${!J[@]}"; do
          echo "J[\"${jk}\"]=\"${J[$jk]}\"" >> $JFILE
        done
        ;;

    # by default jump
    *)
        if [ ${J["$1"]+yes} ]; then
            cd "${J[$1]}"
        else
            echo "J[\"$1\"] entry not found."
        fi
        ;;
  esac
}

