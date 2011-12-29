#!/bin/env bash
#
# bac.bash - Batch Audio Converter
#

# Load data files
. lang.bash         # Language variables
. functions.bash    # Various functions

# Exit if no arguments provided
if [ $# = 0 ]
then
    echo ${NO_ARGS[2]}
    exit ${NO_ARGS[1]}
fi

depchk ()
{
    if ! which $1 2>/dev/null
    then
        echo "${NO_DEP[2]}" "$1"
        exit ${NO_DEP[1]}
    fi
}

search ()
{
    DIR=$1
    
    for FILE in `ls DIR`
    do
        if [ -d "$FILE" ]
        then
            # Check if file is a symbolic link
            if [ -L "$FILE" ]
            then
                echo ${SYM[2]}
                exit ${SYM[1]}
            else
                # If file is a directory, search recursively
                search $FILE
            fi
        else
            # If file is a regular file convert it
            if [ -f "$FILE" ]
            then
                convert $FILE
            fi
        fi
    done
}

convert ()
{
    FILE=$1
    BASE="${FILE%.*}"

    case "${FILE##*.}" in
        mp3)
            mp3_ogg $BASE
            ;;
        wma)
            wma_ogg $BASE
            ;;
        wav)
            wav_flac $BASE
            ;;
    esac
}

# Dependency check
for APP in lame oggenc flac mplayer
do
    depchk $APP
done

# Search input directory
search $1

exit 0
