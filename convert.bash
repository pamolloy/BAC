#!/bin/bash
#
#   caf.bash - A function to convert audio files, 
#+  which is sourced by audio-convert.bash
#

caf() 
{
    # Format in_file = mp3
    if [ "`file -b "$1" | grep 'MP3'`" != "" ] || [ "`echo $1 | grep -i '\.mp3$'`" != "" ]
    then
        if [ "$3" = "ogg" ]
        then # mp3-2-ogg
            if [ $fields -eq 0 ]
            then
                get_field_names "$1"
            fi
            mp3_decode "$1" "$decoding"
            ogg_encode "$1" "$temp_file" "$2"
            rm -f "$temp_file"
            break
        fi
        if [ "$3" = "mpc" ]
        then # mp3-2-mpc
            mp3_decode "$1" "$decoding"
            mpc_encode "$1" "$temp_file" "$2"
            rm -f "$temp_file"
            break
        fi
        if [ "$3" = "flac" ]
        then # mp3-2-flac
            mp3_decode "$1" "$decoding"
            flac_encode "$1" "$temp_file" "$2"
            if [ $fields -eq 0 ]
            then
                get_field_names "$1"
                metaflac --set-tag=ARTIST="$artist_name" "$2"
                metaflac --set-tag=ALBUM="$album_name" "$2"
                metaflac --set-tag=TITLE="$song_name" "$2"
                metaflac --set-tag=TRACKNUMBER="$track_number" "$2"
                break
            fi
            rm -f "$temp_file"
            break
        fi
        if [ "$3" = "ape" ]
        then # mp3-2-ape
            mp3_decode "$1" "$decoding"
            mac_encode "$1" "$temp_file" "$2"
            rm -f "$temp_file"
            break
        fi
        if [ "$3" = "wav" ]
        then # mp3-2-wav
                mp3_decode "$1" "$conversion"
        fi
        break
    fi
    # Format in_file = ogg
    if [ "`file -b "$1" | grep 'Vorbis'`" != "" ] || [ "`echo $1 | grep -i '\.ogg$'`" != "" ]
    then
        if [ "$3" = "mp3" ]
        then # ogg-2-mp3
            ogg_decode "$1" "$decoding"
            mp3_encode "$1" "$temp_file" "$2"
            if [ $fields -eq 0 ]
            then
                get_field_names "$1"
                id3tag -a"$artist_name" -A"$album_name" -s"$song_name" -t"$track_number" "$2"
                break
            fi
            rm -f "$temp_file"
            break
        fi
        if [ "$3" = "mpc" ]
        then # ogg-2-mpc
            ogg_decode "$1" "$decoding"
            mpc_encode "$1" "$temp_file" "$2"
            rm -f "$temp_file"
            break
        fi
        if [ "$3" = "flac" ]
        then # ogg-2-flac
            ogg_decode "$1" "$decoding"
            flac_encode "$1" "$temp_file" "$2"
            if [ $fields -eq 0 ]
            then
                get_field_names "$1"
                metaflac --set-tag=ARTIST="$artist_name" "$2"
                metaflac --set-tag=ALBUM="$album_name" "$2"
                metaflac --set-tag=TITLE="$song_name" "$2"
                metaflac --set-tag=TRACKNUMBER="$track_number" "$2"
                break
            fi
            rm -f "$temp_file"
            break
        fi
        if [ "$3" = "ape" ]
        then # ogg-2-ape
            ogg_decode "$1" "$decoding"
            mac_encode "$1" "$temp_file" "$2"
            rm -f "$temp_file"
            break
        fi
        if [ "$3" = "wav" ]
        then # ogg-2-wav
                ogg_decode "$1" "$conversion"
        fi
        break
    fi
    # Format in_file = mpc
    if [ "`file -b "$1" | grep 'data'`" != "" ] && [ "`echo $1 | grep -i '\.mpc$'`" != "" ]
    then
        if [ "$3" = "mp3" ]
        then # mpc-2-mp3
            mpc_decode "$1" "$decoding"
            mp3_encode "$1" "$temp_file" "$2"
            if [ $fields -eq 0 ]
            then
                get_field_names "$1"
                id3tag -a"$artist_name" -A"$album_name" -s"$song_name" -t"$track_number" "$2"
                break
            fi
            mpc_decode "$1" "$decoding"
            mp3_encode "$1" "$temp_file" "$2"
            rm -f "$temp_file"
            break
        fi
        if [ "$3" = "ogg" ]
        then
            # mpc-2-ogg
            if [ $fields -eq 0 ]
                        then
                        	get_field_names "$1"
			fi
                        mpc_decode "$1" "$decoding"
			ogg_encode "$1" "$temp_file" "$2"
			rm -f "$temp_file"
			break
                fi
		if [ "$3" = "flac" ]
		then # mpc-2-flac
			mpc_decode "$1" "$decoding"
			flac_encode "$1" "$temp_file" "$2"
			if [ $fields -eq 0 ]
                        then
                                get_field_names "$1"
                                metaflac --set-tag=ARTIST="$artist_name" "$2"
                                metaflac --set-tag=ALBUM="$album_name" "$2"
                                metaflac --set-tag=TITLE="$song_name" "$2"
                                metaflac --set-tag=TRACKNUMBER="$track_number" "$2"
                                break
                        fi
			rm -f "$temp_file"
			break
		fi
		if [ "$3" = "ape" ]
		then # mpc-2-ape
			mpc_decode "$1" "$decoding"
			mac_encode "$1" "$temp_file" "$2"
			rm -f "$temp_file"
			break
		fi
                if [ "$3" = "wav" ]
                then # mpc-2-wav
                        mpc_decode "$1" "$conversion"
                fi
		break
        fi
	### Format in_file = flac ###
	if [ "`file -b "$1" | grep 'FLAC'`" != "" ] || [ "`echo $1 | grep -i '\.flac$'`" != "" ]
	then
		if [ "$3" = "mp3" ]
		then # flac-2-mp3
			flac_decode "$1" "$decoding"
                        mp3_encode "$1" "$temp_file" "$2"
			if [ $fields -eq 0 ]
                        then
				get_field_names "$1"
				id3tag -a"$artist_name" -A"$album_name" -s"$song_name" -t"$track_number" "$2"
				break
			fi
			rm -f "$temp_file"
			break
		fi
		if [ "$3" = "ogg" ]
		then # flac-2-ogg
			if [ $fields -eq 0 ]
                        then
				get_field_names "$1"
			fi
			flac_decode "$1" "$decoding"
			ogg_encode "$1" "$temp_file" "$2"
			rm -f "$temp_file"
			break
		fi
		if [ "$3" = "mpc" ]
		then # flac-2-mpc
			flac_decode "$1" "$decoding"
			mpc_encode "$1" "$temp_file" "$2"
			rm -f "$temp_file"
			break
		fi
		if [ "$3" = "ape" ]
		then # flac-2-ape
			flac_decode "$1" "$decoding"
			mac_encode "$1" "$temp_file" "$2"
			rm -f "$temp_file"
			break
		fi
		if [ "$3" = "wav" ]
		then # flac-2-wav
			flac_decode "$1" "$conversion"
		fi
		break
	fi
	### Format in_file = ape ###
	if [ "`file -b "$1" | grep 'data'`" != "" ] && [ "`echo $1 | grep -i '\.ape$'`" != "" ]
	then
		if [ "$3" = "mp3" ]
		then # ape-2-mp3
			mac_decode "$1" "$decoding"
                        mp3_encode "$1" "$temp_file" "$2"
			if [ $fields -eq 0 ]
                        then
				get_field_names "$1"
				id3tag -a"$artist_name" -A"$album_name" -s"$song_name" -t"$track_number" "$2"
				break
			fi
			mac_decode "$1" "$decoding"
			mp3_encode "$1" "$temp_file" "$2"
			rm -f "$temp_file"
			break
		fi
		if [ "$3" = "ogg" ]
		then # ape-2-ogg
			if [ $fields -eq 0 ]
                        then
				get_field_names "$1"
			fi
			mac_decode "$1" "$decoding"
			ogg_encode "$1" "$temp_file" "$2"
			rm -f "$temp_file"
			break
		fi
		if [ "$3" = "mpc" ]
		then # ape-2-mpc
			mac_decode "$1" "$decoding"
			mpc_encode "$1" "$temp_file" "$2"
			rm -f "$temp_file"
			break
		fi
		if [ "$3" = "flac" ]
		then #ape-2-flac
			mac_decode "$1" "$decoding"
			flac_encode "$1" "$temp_file" "$2"
			if [ $fields -eq 0 ]
                        then
                                get_field_names "$1"
                                metaflac --set-tag=ARTIST="$artist_name" "$2"
                                metaflac --set-tag=ALBUM="$album_name" "$2"
                                metaflac --set-tag=TITLE="$song_name" "$2"
                                metaflac --set-tag=TRACKNUMBER="$track_number" "$2"
                                break
                        fi
			rm -f "$temp_file"
			break
		fi
		if [ "$3" = "wav" ]
		then #ape-2-wav
			mac_decode "$1" "$conversion"
		fi
		break
	fi
        ### Format in_file = wav ###
        if [ "`file -b "$1" | grep 'WAVE'`" != "" ] || [ "`echo $1 | grep -i '\.wav$'`" != "" ]
        then
                if [ "$3" = "mp3" ]
                then # wav-2-mp3
			mp3_encode "$1" "$1" "$2"
			if [ $fields -eq 0 ]
                        then
	                        get_field_names "$1"
				id3tag -a"$artist_name" -A"$album_name" -s"$song_name" -t"$track_number" "$2"
				break
			fi
			break
                fi
                if [ "$3" = "ogg" ]
                then # wav-2-ogg
			if [ $fields -eq 0 ]
                        then
	                        get_field_names "$1"
			fi
                        ogg_encode "$1" "$1" "$2"
			break
                fi
                if [ "$3" = "mpc" ]
                then # wav-2-mpc
                        mpc_encode "$1" "$1" "$2"
                fi
		if [ "$3" = "flac" ]
		then # wav-2-flac
			flac_encode "$1" "$1" "$2"
			if [ $fields -eq 0 ]
                        then
                                get_field_names "$1"
                                metaflac --set-tag=ARTIST="$artist_name" "$2"
                                metaflac --set-tag=ALBUM="$album_name" "$2"
                                metaflac --set-tag=TITLE="$song_name" "$2"
                                metaflac --set-tag=TRACKNUMBER="$track_number" "$2"
                                break
                        fi
		fi
		if [ "$3" = "ape" ]
		then # wav-2-ape
			mac_encode "$1" "$1" "$2"
		fi
		break
        fi
        ### Format in_file = wma ###
        if [ "`file -b "$1" | grep 'Microsoft'`" != "" ] || [ "`echo $1 | grep -i '\.wma$'`" != "" ]
        then
                if [ "$3" = "mp3" ]
                then # wma-2-mp3
			wma_decode "$1" "$decoding"
                        mp3_encode "$1" "$temp_file" "$2"
			if [ $fields -eq 0 ]
                        then
	                        get_field_names "$1"
				id3tag -a"$artist_name" -A"$album_name" -s"$song_name" -t"$track_number" "$2"
				break
			fi
                        rm -f "$temp_file"
			break
                fi

                if [ "$3" = "wav" ]
                then # wma-2-wav
                        wma_decode "$1" "$conversion"
                fi

                if [ "$3" = "ogg" ]
                then # wma-2-ogg
			if [ $fields -eq 0 ]
                        then
	                        get_field_names "$1"
			fi
                        wma_decode "$1" "$decoding"
                        ogg_encode "$1" "$temp_file" "$2"
                        rm -f "$temp_file"
			break
                fi
                if [ "$3" = "mpc" ]
                then # wma-2-mpc
                        wma_decode "$1" "$decoding"
                        mpc_encode "$1" "$temp_file" "$2"
                        rm -f "$temp_file"
			break
                fi
		if [ "$3" = "flac" ]
		then # wma-2-flac
			wma_decode "$1" "$decoding"
			flac_encode "$1" "$temp_file" "$2"
			if [ $fields -eq 0 ]
                        then
                                get_field_names "$1"
                                metaflac --set-tag=ARTIST="$artist_name" "$2"
                                metaflac --set-tag=ALBUM="$album_name" "$2"
                                metaflac --set-tag=TITLE="$song_name" "$2"
                                metaflac --set-tag=TRACKNUMBER="$track_number" "$2"
                                break
                        fi
			rm -f "$temp_file"
			break
		fi
		if [ "$3" = "ape" ]
		then # wma-2-ape
			wma_decode "$1" "$decoding"
			mac_encode "$1" "$temp_file" "$2"
			rm -f "$temp_file"
			break
		fi
		break
        fi
}

