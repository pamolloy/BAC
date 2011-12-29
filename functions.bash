#!/bin/bash
#
#   functions.bash - Various functions to be sourced by bac.bash
#

wav_flac ()
{
    flac --keep-foreign-metadata --best --force --silent "$1".wav
    flac --test "$1".flac
}

ogg_encode ()
{
    oggenc --quality 5 "$1"
}

mp3_ogg ()
{
    lame --decode "$1".mp3
    ogg_encode "$1".wav
}

wma_ogg ()
{
    mplayer -quiet -ao pcm:file="$1".wav -vc null -vo null "$1".wma
    ogg_encode "$1".wav
}

