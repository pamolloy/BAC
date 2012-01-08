#!/bin/bash
#
#   functions.bash - Various functions to be sourced by bac.bash
#

wav_flac ()
{
    flac --keep-foreign-metadata --best --force --silent "$1".wav
    flac --test --silent "$1".flac
    if [ $? -eq 0 ]
    then
        rm "$1".wav
    fi
}

ogg_encode ()
{
    oggenc --quality 8 --output="$2" "$1"
}

mp3_ogg ()
{
    lame --decode "$1".mp3
    ogg_encode "$1".wav
    if [ $? -eq 0 ]
    then
        rm "$1".mp3
        rm "$1".wav
    fi
}

wma_ogg ()
{
    # MPlayer always returns an exit status of 0 and splits filenames with
    # commas when trying to output a new file using -ao
    mplayer -quiet -ao pcm -vc null -vo null "$1".wma
    ogg_encode audiodump.wav "$1".ogg
    if [ $? -eq 0 ]
    then
        rm "$1".wma
        rm audiodump.wav
    else
        echo ${CONVERT[2]} "$1"
        exit ${CONVERT[1]}
    fi
}

