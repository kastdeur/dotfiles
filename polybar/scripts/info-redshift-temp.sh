#!/bin/sh

if [ "$(pgrep -x redshift)" ]; then
    temp=$(redshift -p 2> /dev/null | grep temp | cut -d ":" -f 2 | tr -dc "[:digit:]")

    if [ -z "$temp" ]; then
        echo "%{F#666} ﯧ"
    elif [ "$temp" -ge 5000 ]; then
        echo "%{F#ffeeee} ﯦ"
    elif [ "$temp" -ge 4000 ]; then
        echo "%{F#ffaaaa} ﯦ"
    else
        echo "%{F#ff0000} ﯦ"
    fi
fi
