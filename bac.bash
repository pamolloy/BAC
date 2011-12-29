#!/bin/bash
#
# bac.bash - Batch Audio Converter
#
# TODO
#   - Save meta data to new files

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
    
    for FILE in "$DIR"*
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
                echo "Searching: $FILE"
                search "$FILE"/
            fi
        elif [ -f "$FILE" ]
        then
            # If file is a regular file verify it
            echo "Checking: $FILE"
            verify "$FILE"
        fi
    done
}

verify ()
{
    FILE=$1
    BASE="${FILE%.*}"

    #TODO (PM) Case insensitive matching
    case "${FILE##*.}" in
        mp3)
            if [ -f "$BASE".wav ]
            then
                rm "$FILE".mp3
            else
                mp3_ogg "$BASE"
            fi
            ;;
        wma)
            if [ -f "$BASE".wav ]
            then
                rm "$FILE".wma
            else
                wma_ogg "$BASE"
            fi
            ;;
        wav)
            echo "Converting: $FILE"
            wav_flac "$BASE"
            ;;
        jpg)
            rm "$FILE"
            ;;
        # desktop.ini
        ini)
            rm "$FILE"
            ;;
        # Thumbs.db
        db)
            rm "$FILE"
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
