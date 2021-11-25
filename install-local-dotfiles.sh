#!/usr/bin/env bash

set -e

case "$1" in
	-h|--help|--usage)
		echo "$0: [local-dotfile-directory]"
		echo
		echo "Retrieves a local dotfile repository and puts it at \$local-dotfile-directory."
		exit 0
		;;
esac

LOCAL_DIR="${1:-$HOME/.dotfiles-local}"
LOCAL_GIT="git@git.deboone.nl:ericteunis/dotfiles-local.git"

git clone $LOCAL_GIT $LOCAL_DIR

# Optionally run the install script directly
if false; then
	$LOCAL_DIR/install.sh
fi
