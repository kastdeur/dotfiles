
BASE="$HOME/.dotfiles"
BAKSUFFIX=".old"

symlink()
{
	local COMMAND='ln -s '
	[ $# -lt 2 ] && return 1

	[ $# -gt 2 ] && [ "$3" = "-c" -o "$3" = "--copy" ] $COMMAND = 'echo "cp -r" '

	if [ ! -h $2 ]; then
		echo "MOVING mv \"$2\" \"$2$BAKSUFFIX\" "
	fi


	$COMMAND "$1" "$2" 
}


# bash
symlink "${BASE}/bashrc" ~/.bashrc
symlink "${BASE}/bash_files/" ~/.bash_files

# vim
symlink "${BASE}/vimrc" ~/.vimrc
symlink "${BASE}/vim/" ~/.vim

# tmux
symlink "${BASE}/tmux.conf" ~/.tmux.conf

# ssh
symlink "${BASE}/ssh/" ~/.ssh

