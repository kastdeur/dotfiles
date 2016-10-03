#!/bin/sh
#Standard Stuff
. /etc/X11/xinit/xinitrc-common
if [ -f $HOME/.Xclients ]; then
    exec $CK_XINIT_SESSION $SSH_AGENT $HOME/.Xclients || \
    exec $CK_XINIT_SESSION $SSH_AGENT $HOME/.Xclients
elif [ -f /etc/X11/xinit/Xclients ]; then
    exec $CK_XINIT_SESSION $SSH_AGENT /etc/X11/xinit/Xclients || \
    exec $CK_XINIT_SESSION $SSH_AGENT /etc/X11/xinit/Xclients
else
    # Failsafe settings.  Although we should never get here
    # (we provide fallbacks in Xclients as well) it can't hurt.
    [ -x /usr/bin/xsetroot ] && /usr/bin/xsetroot -solid '#222E45'
    [ -x /usr/bin/xclock ] && /usr/bin/xclock -geometry 100x100-5+5 &
    [ -x /usr/bin/xterm ] && xterm -geometry 80x50-50+150 &
    [ -x /usr/bin/twm ] && /usr/bin/twm
fi
# ---------------------------------------------------------------
#	 OWN
# ---------------------------------------------------------------



# Load session
DEFAULT_SESSION=awesome
XTERM=xterm
case $1 in
	xfce4)
		exec startxfce4
		;;
	awesome)
		xscreensaver -nosplash &
		nm-applet &
		exec awesome >> $HOME/.cache/awesome/stdout 2>> $HOME/.cache/awesome/stderr
		;;
	enlightenment)
		exec enlightenment_start
		;;
	openbox)
		exec openbox
		;;
	cinnamon)
		exec cinnamon
		;;
	kde)
		exec startkde
		;;
	gnome)
		exec gnome-session
		;;
	unity)
		exec unity
		;;
	xterm)
		exec xterm
		;;
	*)
		exec $DEFAULT_SESSION
		;;
esac
