#!/usr/bin/env bash

readonly base58_sh
declare base58_chars_str="123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
unset dcr; for i in {1..58}; do dcr+="${i}s${base58_chars_str:$i:1}"; done

base58() {
  if
    local OPTIND OPTARG o
    getopts hdvc o
  then
    shift $((OPTIND - 1))
    local input
    case $o in
      d)
	read -r input < "${1:-/dev/stdin}"
	if [[ "$input" =~ ^1.+ ]]
	then printf "\x00"; ${FUNCNAME[0]} -d <<<"${input:1}"
	elif [[ "$input" =~ ^[$base58_chars_str]+$ ]]
	then sed -e "i$dcr 0" -e 's/./ 58*l&+/g' -e "aP" <<<"$input" | dc
        elif [[ -z "$input" ]]
        then return 0
	else return 2
	fi |
	if [[ -t 1 ]]
	then cat -v
	fi
        ;;
      v)
        tee >(${FUNCNAME[0]} -d "$@" |head -c -4 |${FUNCNAME[0]} -c) |
        uniq | wc -l |
	grep -q '^1$'
        ;;
      c)
	tee >(
           openssl dgst -sha256 -binary |
	   openssl dgst -sha256 -binary |
	   head -c 4
        ) | ${FUNCNAME[0]} "$@"
        ;;
      h)
        cat <<-END_USAGE
	${FUNCNAME[0]} [options] [FILE]
	
	options are:
	  -h:	show this help
	  -d:	decode from base58 to binary
	  -c:	append checksum
          -v:	verify checksum
	END_USAGE
        return
        ;;
    esac
  else
    xxd -p -c 1 "${1:-/dev/stdin}" |
    sed 's/^/0x/' |
    {
      local -i bytes
      mapfile -t bytes
      while ((${#bytes[@]} > 0)) && ((${bytes[0]} == 0))
      do echo -n 1; bytes=(${bytes[@]:1})
      done
      if ((${#bytes[@]} > 0))
      then
	{
	  echo 0
	  printf "256*%d+\n" ${bytes[@]}
	  echo '[58~rd0<x]dsxx+f'
	} |
	dc |
	while read -r
	do echo -n "${base58_chars_str:$REPLY:1}"
	done
      fi
      echo
    }
  fi
}
