DOTFILES="$HOME/.dotfiles"
#Add DOTFILES/bin/ to PATH
DOTBIN="$DOTFILES/bin"
if [ -d "$DOTBIN" ]; then
	export PATH="$PATH:$DOTBIN"
fi


# Always try to use vi(m) if possible
export EDITOR="vi"


# Source Envs
DOTENVS="$HOME/.envs"
if [ -d "DOTENVS" ]; then
	source "$DOTENVS/*.active"
fi



# Source Bashrc if BASH
if [ "$BASH" ] && [ -f $DOTFILES/bash/bashrc ]; then
	source $DOTFILES/bash/bashrc
fi
