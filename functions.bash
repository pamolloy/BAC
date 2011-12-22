#!/bin/bash
#
#   functions.bash - Various functions to be sourced by bac.bash
#

get_ogg_quality ()
{
        zenity --title="$title" --list --radiolist --column="" --column="$ask_quality" -- "-1" FALSE "0" FALSE "1" FALSE "2" FALSE "3" FALSE "4" FALSE "5" FALSE "6" TRUE "7" FALSE "8" FALSE "9" FALSE "10"
}

get_mp3_quality ()
{
        zenity --title="$title" --list --radiolist --column="" --column="$ask_quality" FALSE "medium" FALSE "standard" TRUE "extreme" FALSE "insane"
}

get_mpc_quality ()
{
        zenity --title="$title" --list --radiolist --column="" --column="$ask_quality" FALSE "thumb" FALSE "radio" TRUE "standard" FALSE "xtreme"
}

get_flac_quality ()
{
	zenity --title="$title" --list --radiolist --column="" --column="$ask_quality" FALSE "0" FALSE "1" FALSE "2" FALSE "3" FALSE "4" FALSE "5" FALSE "6" FALSE "7" TRUE "8"
}

get_mac_quality ()
{
	zenity --title="$title" --list --radiolist --column="" --column="$ask_quality" FALSE "1000" FALSE "2000" TRUE "3000" FALSE "4000" FALSE "5000"
}

get_quality ()
{
	if [ "$1" == "mp3" ]
	then
		quality="$(get_mp3_quality)"
	fi
        if [ "$1" == "ogg" ]
        then
                quality="$(get_ogg_quality)"
        fi
        if [ "$1" == "mpc" ]
        then
                quality="$(get_mpc_quality)"
        fi
        if [ "$1" == "flac" ]
        then
                quality="$(get_flac_quality)"
        fi
        if [ "$1" == "ape" ]
        then
                quality="$(get_mac_quality)"
        fi
}

mp3_encode ()
{
	lame -m auto --preset $quality "$2" "$3" 2>&1 | awk -vRS='\r' '(NR>3){gsub(/[()%|]/," ");print $2; fflush();}' | zenity --progress --title="$title" --text="$conversion $1" --auto-close
}

ogg_encode ()
{
	if [ $fields -eq 0 ]
	then
		oggenc "$2" -a "$artist_name" -l "$album_name" -t "$song_name" -N "$track_number" -q $quality -o "$3" 2>&1 | awk -vRS='\r' '(NR>1){gsub(/%/," ");print $2; fflush();}' | zenity --progress --title="$title" --text="$conversion $1" --auto-close
	else
		oggenc "$2" -q $quality -o "$3" 2>&1 | awk -vRS='\r' '(NR>1){gsub(/%/," ");print $2; fflush();}' | zenity --progress --title="$title" --text="$conversion $1" --auto-close
	fi
}

mpc_encode ()
{
	mppenc --$quality "$2" "$3" 2>&1 | awk -vRS='\r' '!/^$/{if (NR>5) print $1; fflush();}' | zenity --progress --title="$title" --text="$conversion $1" --auto-close
}

flac_encode ()
{
	flac --compression-level-$quality "$2" -o "$3" 2>&1 | awk -vRS='\r' -F':' '!/wrote/{gsub(/ /,"");if(NR>1)print $2; fflush();}' | awk -F'%' '{print $1; fflush();}' | zenity --progress --title="$title" --text="$conversion $1" --auto-close
}

mac_encode ()
{
	mac "$2" "$3" -c$quality 2>&1 | awk -vRS='\r' '(NR>1){gsub(/%/," ");print $2; fflush();}' | zenity --progress --title="$title" --text="$conversion $1" --auto-close
}

mp3_decode ()
{
	temp_file=`echo "$1" | sed 's/\.\w*$/'.wav'/'`
	lame --decode "$1" "$temp_file" 2>&1 | awk -vRS='\r' -F'[ /]+' '(NR>2){if((100*$2/$3)<=100)print 100*$2/$3; fflush();}' | zenity --progress --title="$title" --text="$2 $1" --auto-close
}

ogg_decode ()
{
	temp_file=`echo "$1" | sed 's/\.\w*$/'.wav'/'`
	oggdec "$1" -o "$temp_file" 2>&1 | awk -vRS='\r' '(NR>1){gsub(/%/," ");print $2; fflush();}' | zenity --progress --title="$title" --text="$2 $1" --auto-close
}

mpc_decode ()
{
	temp_file=`echo "$1" | sed 's/\.\w*$/'.wav'/'`
	mppdec "$1" "$temp_file" 2>&1 | awk -vRS='\r' -F'[ (]+' '!/s/{gsub(/(%)/," ");if(NR>5)print $5; fflush();}' | zenity --progress --title="$title" --text="$2 $1" --auto-close
}

flac_decode ()
{
	temp_file=`echo "$1" | sed 's/\.\w*$/'.wav'/'`
	flac -d "$1" -o "$temp_file" 2>&1 | awk -vRS='\r' -F':' '!/done/{gsub(/ /,"");gsub(/% complete/,"");if(NR>1)print $2; fflush();}' | zenity --progress --title="$title" --text="$2 $1" --auto-close
}

mac_decode ()
{
	temp_file=`echo "$1" | sed 's/\.\w*$/'.wav'/'`
	mac "$1" "$temp_file" -d 2>&1 | awk -vRS='\r' '(NR>1){gsub(/%/," ");print $2; fflush();}' | zenity --progress --title="$title" --text="$2 $1" --auto-close
}

wma_decode ()
{
	temp_file=`echo "$1" | sed 's/\.\w*$/'.wav'/'`
	mplayer -ao pcm:file="$temp_file" "$1" 2>&1 | awk -vRS='\r' '(NR>1){gsub(/%/," ");print 100-$5; fflush();}' | zenity --progress --title="$title" --text="$2 $1" --auto-close
}

ask_for_fields ()
{
	zenity --question --text="$ask_fields"
	fields=$?
}

ask_for_confirmation ()
{
	zenity --question --text="$ask_confirmation_question"
	confirmation_question=$?
}

