#
# ~/.dotfiles/profiles/main.sh
#
DOTFILES="$XDG_DOTFILES_DIR"


addpath() { case ":${PATH:=$1}:" in *:$1:*) ;; *) PATH="$1:$PATH" ;; esac; }

# add ~/.local/bin to PATH
if [ -d "~/.local/bin" ]
then
	addpath "~/.local/bin"
fi

# add DOTFILES/bin to PATH
DOTBIN="$DOTFILES/bin"
if [ -d "$DOTBIN" ]
then
	addpath "$DOTBIN"
fi

# use vi(m) if possible
export EDITOR="vi"
export VISUAL="vi"


# Source Envs
DOTENVS="$DOTFILES/envs.d"
if [ -d "$DOTENVS" ]
then
	for f in "$DOTENVS/*.active"
	do
		if [ "$f" = "$DOTENVS/*.active" ]
		then
			break
		fi

		source "$f"
	done
fi

# if this is BASH source BASHRC
if [ "$BASH" ] && [ -f $DOTFILES/bash/rc ]
then
	source $DOTFILES/bash/rc
fi
