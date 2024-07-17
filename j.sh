#!/usr/bin/bash

#
# 
# Copyright (c) 2016-2024 Sriram Srinivasan.
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to
# whom the Software is furnished to do so, subject to the
# following conditions:
# 
# The above copyright notice and this permission notice shall
# be included in all copies or substantial portions of the
# Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
# KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
# 

# A small tool to quickly jump between directories

JFILE=~/.jfile

declare -A J

if [ -f $JFILE ]; then
    source $JFILE
fi


function _j_jump() {
		if [ "$1" == "~" ]; then
				J["~"]=~
		fi
		if [ "${J["-"]}" == "" ]; then
				J["-"]=`pwd`
		fi
    if [ ${J["$1"]+yes} ]; then
				_d=${J["$1"]}
        if [ -d "$_d" ]; then
						if [ "$_d" == "`pwd`" ]; then
								:
						else
								J["-"]=`pwd`
								cd "$_d"
						fi
        fi
    else
		    # J entry not found; so try cd
        if [ -d "$1" ]; then
            cd "$1"
        else
						#TODO: may be add some fuzzy search
            echo "J[\"$1\"] entry or dir: $1 not found"
        fi
    fi
}

function j() {

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

    # by default just jump
    *)
				if [ "$1" == "" ]; then
						_j_jump "-"
				else
						_j_jump "$@"
				fi
        ;;
  esac
}

