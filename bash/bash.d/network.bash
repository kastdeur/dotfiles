#!/bin/bash

function data_url() {
  if [ -z "$1" ]; then
    cat << EndOfMessage
Create a data URL that can be directly used in HTML.
Usage: data_url <path_to_file>
EndOfMessage
    return
  fi
	local mime_type base64
  mime_type=$(file -b --mime-type "$1")
  if [[ "$mime_type" == 'image/svg' ]]; then
    mime_type='image/svg+xml'
  fi
  base64=$(base64 "$1")
	echo "data:$mime_type;base64,$base64";
}
