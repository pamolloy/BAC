#!/bin/bash
#
#   lang.bash - Language variables (ISO 639-1) sourced by bac.bash
#

## Default: en
# User prompt
META_DATA="Would you like to retain the meta data?"
QUALITY="How many quality would you like?"

# Error handling
NO_DEP[1]=84
NO_DEP[2]="Missing a required dependency:"
NO_ARGS[1]=85
NO_ARGS[2]="Please select at least one input."
SYM[1]=87
SYM[2]="Symbolic links can not be processed."
CONVERT[1]=88
CONVERT[2]="Conversion failed for:"

case "$LANG" in
    fr)
    ;;
    it)
    ;;
    pt)
    ;;
    nl)
    ;;
    de)
    ;;
esac

