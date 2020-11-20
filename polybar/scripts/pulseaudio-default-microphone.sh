#!/bin/sh

PACMD="pacmd"

status() {
  MUTED=$($PACMD list-sources | awk '/\*/,EOF {print}' | awk '/muted/ {print $2; exit}')

  if [ "$MUTED" = "yes" ]; then
    echo "%{F#F00}"
  else
    echo ""
  fi
}

listen() {
    status

    LANG=EN; pactl subscribe | while read -r event; do
        if echo "$event" | grep -q "source" || echo "$event" | grep -q "server"; then
            status
        fi
    done
}

toggle() {
  MUTED=$($PACMD list-sources | awk '/\*/,EOF {print}' | awk '/muted/ {print $2; exit}')
  DEFAULT_SOURCE=$($PACMD list-sources | awk '/\*/,EOF {print $3; exit}')

  if [ "$MUTED" = "yes" ]; then
      $PACMD set-source-mute "$DEFAULT_SOURCE" 0
  else
      $PACMD set-source-mute "$DEFAULT_SOURCE" 1
  fi
}

increase() {
  DEFAULT_SOURCE=$($PACMD list-sources | awk '/\*/,EOF {print $3; exit}')
  $PACMD set-source-volume "$DEFAULT_SOURCE" +5%
}

decrease() {
  DEFAULT_SOURCE=$($PACMD list-sources | awk '/\*/,EOF {print $3; exit}')
  $PACMD set-source-volume "$DEFAULT_SOURCE" -5%
}

case "$1" in
    --toggle)
        toggle
        ;;
	--increase)
		increase
		;;
	--decrease)
		decrease
		;;
    *)
        listen
        ;;
esac
