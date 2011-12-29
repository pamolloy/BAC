#!/bin/bash
#
#   functions.bash - Various functions to be sourced by bac.bash
#

wav-flac ()
{
    flac "$1".wav --keep-foreign-metadata --best
    flac --test "$1".flac
}

ogg-encode ()
{
    oggenc --quality 5 $1
}

mp3-ogg ()
{
    lame --decode "$1".mp3
    ogg-encode "$1".wav
}

wma_ogg ()
{
    mplayer -ao pcm:file="$1".wav -vc null -vo null
    ogg-encode "$1".wav
}

aac_ogg ()
{
    #TODO (PM) Add AAC conversion
}
