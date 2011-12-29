#!/bin/bash
#
#   functions.bash - Various functions to be sourced by bac.bash
#
# TODO
#   - Test each file before removing it

wav_flac ()
{
    flac --keep-foreign-metadata --best --force --silent "$1".wav
    if [ `flac --test "$1".flac` ]
    then
        rm "$1".wav
    fi
}

ogg_encode ()
{
    oggenc --quality 5 "$1"
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
    # MPlayer always returns an exit status of 0
    mplayer -quiet -ao pcm:file="$1".wav -vc null -vo null "$1".wma
    ogg_encode "$1".wav
    if [ $? -eq 0 ]
    then
        rm "$1".wma
        rm "$1".wav
    fi
}

