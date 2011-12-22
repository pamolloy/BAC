#!/bin/env bash
#
# bac.bash - Batch Audio Converter
#

# Load data files
. lang.bash     # Language variables
. functions.bash # Various functions
. convert.bash  # Function to convert audio files

# Exit if no arguments provided
if [ $# = 0 ]
then
    local FILE=$1
else
    echo ${NO_ARGS[2]}
    exit ${NO_ARGS[1]}
fi

# Dependency check
DEPS = ( 0 0 0 0 0 0 )
case "${FILE##*.}" in
    mp3)
        if which lame 2>/dev/null
            DEPS[1]=1
        else
            echo ${NO_DEP[2]}
            exit ${NO_DEP[1]}
        ;;
    ogg)
        if which oggenc 2>/dev/null
            DEPS[2]=1
        else
            echo ${NO_DEP[2]}
            exit ${NO_DEP[1]}
        ;;
    mpc)
        if which mppenc 2>/dev/null
            DEPS[3]=1
        else
            echo ${NO_DEP[2]}
            exit ${NO_DEP[1]}
        ;;
    flac)
        if which flac 2>/dev/null
            DEPS[4]=1
        else
            echo ${NO_DEP[2]}
            exit ${NO_DEP[1]}
        ;;
    ape)
        if which mac 2>/dev/null
            DEPS[5]=1
        else
            echo ${NO_DEP[2]}
            exit ${NO_DEP[1]}
        ;;
    wav)
        DEPS[6]=1
        ;;
esac

## Options - prompt user for input
ENCODE= #TODO (PM) Store user input in variable

# Output filename
BASENAME="${FILE%.*}"
FILENAME="$BASENAME.$EXTENSION" #TODO (PM) Create variable
if [ -e "$FILENAME" ] # Check existence of output filename in PWD
then
    echo ${FILE_EXIST[2]}
    #TODO (PM) Prompt user to overwrite file
    if #TODO (PM) If user does NOT want to overwrite
        exit ${FILE_EXIST[1]}
fi

# Meta data conversion for MP3, OGG, or FLAC codecs
for CODEC in 1 2 4
do
    if [ "${DEPS[CODEC]}" == 1 ]
    then
        echo $META_DATA
        # Store user input
    fi
done

# Compression quality
if [ "${DEPS[6]}" == 1 ]
then
    echo $QUALITY
    # Store user input
fi

## Convert audio file
caf "$in_file" "$out_file" "$formatout"

exit 0
