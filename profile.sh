# Define XDG_DOTFILES_DIR for easy access
export XDG_DOTFILES_DIR="$HOME/.dotfiles"
export XDG_CONFIG_HOME="$HOME/.config"

# Source main profile
[ -r "$XDG_DOTFILES_DIR/profiles/main.sh" ] && source "$XDG_DOTFILES_DIR/profiles/main.sh"

# Source machine specific profile
[ -r "$XDG_DOTFILES_DIR/profiles/$HOSTNAME.profile" ] && source "$XDG_DOTFILES_DIR/profiles/$HOSTNAME.profile"

# Always source a local profile
[ -r "$HOME/.profile.local" ] && source "$HOME/.profile.local"

# Use the local(ly linked) profile.private
[ -r "$HOME/.local/profile.private" ] && source "$HOME/.local/profile.private"

# Also check in .local for a profile
[ -r "$HOME/.local/profile" ] && source "$HOME/.local/profile"
