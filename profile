# Define DOTFILES for easy access
DOTFILES="$HOME/.dotfiles"

# Add DOTFILES/bin/ to PATH
DOTBIN="$HOME/.bin"
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
if [ "$BASH" ] && [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi