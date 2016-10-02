# Define DOTFILES for easy access
DOTFILES="$HOME/.dotfiles"

# Source main profile
[ -r "$DOTFILES/profiles/main.sh" ] && source "$DOTFILES/profiles/main.sh"

# Source machine specific profile
[ -r "$DOTFILES/profiles/$HOSTNAME.profile" ] && source "$DOTFILES/profiles/$HOSTNAME.profile"

# Always source a local profile
[ -r "$HOME/.profile.local" ] && source "$HOME/.profile.local"
