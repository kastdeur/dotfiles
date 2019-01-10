DOTFILES="$HOME/.dotfiles"
#Add DOTFILES/bin/ to PATH
DOTBIN="$DOTFILES/bin"

addpath() { case ":${PATH:=$1}:" in *:$1:*) ;; *) PATH="$1:$PATH" ;; esac; }

if [ -d "$DOTBIN" ]
then
	addpath "$DOTBIN"
fi

if [ -d "~/.local/bin" ]
then
	addpath "~/.local/bin"
fi


# Always try to use vi(m) if possible
export EDITOR="vi"


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

# Source Bashrc if BASH
if [ "$BASH" ] && [ -f $DOTFILES/bash/rc ]
then
	source $DOTFILES/bash/rc
fi
