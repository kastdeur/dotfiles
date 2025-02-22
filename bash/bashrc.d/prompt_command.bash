# .bash_files
# /PS

# Set default to empty so it will show up in printenv
SHORTPS1=${SHORTPS1:-}
export SHORTPS1

STATICPS1=${STATICPS1:-}
export STATICPS1

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and
	# a case would tend to support setf rather than setaf.)
	    color_prompt=yes
    else
	    color_prompt=
    fi
fi

# Make sure we have the VTE thing when we define our prompt command

#if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    #source /etc/profile.d/vte.sh
#fi

# Old PS1
#if [ "$color_prompt" = yes ]; then
#	PS1='${debian_chroot:+($debian_chroot)}\[\033[00;32m\]\u@\H\[\033[00m\] \[\033[0;33;40m\](\t)\[\033[00m\] \[\033[01;34m\]\[$(ls |wc -l)\]@\W\[\033[00m\]:\$ '
#else
#	PS1='${debian_chroot:+($debian_chroot)}\u@\H (\t) \[$(ls | wc -l)\]@\W:\$ '
#fi


function color() {
	if [ -n "$force_color_prompt" ] ; then
		if [ -n "$color_prompt" ] ; then
			return 0
		else
			return 1
		fi
	else
		return 1
	fi
}

function vte_thing() {
#	if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
	#	__vte_osc7
#	fi
	true
}

export PROMPT_COMMAND=__prompt_command

function __PS1_hostname() {
	# returns a formatted hostname
	local color="${2:-$(color)}"

	# no colours? no need to run
	if ! color ; then
		echo "\h";
		return
	fi

	local HOST="${1:-$HOSTNAME}"
	local PS1
	local NOMATCH
	local func_extension="__PS1_hostname_extended"

	# check selected hostnames
	case "${HOST%%.*}" in
		'locksmith')   PS1+="${Pur}\h${RCol}";;
		'bladesmith')  PS1+="${Yel}\h${RCol}";;
		'goldsmith')   PS1+="${IYel}\h${RCol}";;
		*) NOMATCH=1;;
	esac

	if [ -n "${NOMATCH}" ]; then
		if [ x$(type -t "$func_extension") = xfunction ]; then
			NOMATCH=$($func_extension "$@")
		else
			NOMATCH=""
		fi

		# extended colouring
		if [ -n "${NOMATCH}" ]; then
			PS1+="${NOMATCH}"
		# default colouring
		else
			PS1+="${Blu}${On_Whi}\h${RCol}";
		fi
	fi

	echo "$PS1"
}

function __colored_username() {
    local USER="${1:-$USER}"
	local color="${2:-$(color)}"
	local PS1

	if color ; then
		case "${USER}" in
			'root') PS1+="${Red}\u${RCol}";;
			'kastdeur'|'ericteunis'|'deboone')  PS1+="${Gre}\u${RCol}";;
			*)      PS1+="${Blu}\u${RCol}";;
		esac
	else
		PS1+="\u"
	fi

	echo "$PS1"
}

function __prompt_command() {
	local STATIC_PS1="${1:-${STATICPS1}}"
	local RETVAL=$?
	if [ ! $RETVAL -ne 0 ]; then
		RETVAL=0
	fi

	PS1="${debian_chroot:+($debian_chroot)}"

	if [ -z "${STATIC_PS1}" ]; then
		### Add Return Value ###
		if [ -n $RETVAL ]; then
			PS1+="$(retval ${RETVAL})"
		fi

		### Add amount of jobs ###
		if true; then
			PS1+="$(jobscount)"
		fi
	
		### Add Git Status ###
		if [[ $(command -v git) ]]; then
			PS1+="$(git_status)"
		fi

		PS1+=" "
	fi

	PS1+="$(parse_python_venv)"

	# user@hostname
	if color ; then
		PS1+="$(__colored_username)"
	else
		PS1+="\u"
	fi

	PS1+="@"

	if color ; then
		PS1+="$(__PS1_hostname)"
	else 
		PS1+="\h"
	fi

	# time w/ seconds
	if color ;  then
		PS1+="${Yel}${On_Bla}"
	fi
	
	PS1+="(\t)"

	if color ; then
		PS1+="${RCol}"
	fi

	# dir count, pwd
	PS1+=" "
	if color ; then
		PS1+="${BBlu}"
	fi

	if [ -z "${STATIC_PS1}" ]; then
		PS1+="\[$(ls |wc -l)\]@"
	fi

	PS1+="\W"

	if color ; then
		PS1+="${RCol}"
	fi
	PS1+=" "
	## Short prompt
	if [ -n "${SHORTPS1}" ]; then
		PS1+="\r\n"
	fi
	# UID
	PS1+=':\$ '

	# Something for VTE
	PS1+=$(vte_thing)

}

function retval() {
### Determine Return Value
	local PS1
	if [ -z "$color_prompt" ]; then
		PS1="[$1] "
	else
		if [ ! $1 == 0 ]; then
			PS1="${Red}x${RCol}"
		else
			PS1="${Gre}+${RCol}"
		fi
	fi

	echo "${PS1}"
}

### count jobs
function jobscount() {
  local stopped=$(jobs -sp | wc -l)
  local running=$(jobs -rp | wc -l)
  ((running+stopped)) && echo -n "${IYel}${running}${RCol}|${Yel}${stopped}${RCol}"
}

function git_status() {
### Determine Git Status
		local PS1
		local GStat="$(git status --porcelain -b 2>/dev/null | tr '\n' ':')"

		if [ "$GStat" ]; then
			### Fetch Time Check ### {{{
			local LAST=$(stat -c %Y $(git rev-parse --git-dir 2>/dev/null)/FETCH_HEAD 2>/dev/null)
			if [ "${LAST}" ]; then
				local TIME=$(echo $(date +"%s") - ${LAST} | bc)
				## Check if more than 60 minutes since last
				if [ "${TIME}" -gt "3600" ]; then
					git fetch 2>/dev/null
					PS1+='+ '
					## Refresh var
					local GStat="$(git status --porcelain -b 2>/dev/null | tr '\n' ':')"
				fi
			fi
			### End Fetch Check ### }}}

			### Test For Changes ### {{{
			## Change this to test for 'ahead' or 'behind'!
			local GChanges="$(echo ${GStat} | tr ':' '\n' | grep -v "^$" | grep -v "^##" | wc -l | tr -d ' ')"
			if [ "$GChanges" == "0" ]; then
				local GitCol=$Gre
			  else
				local GitCol=$Red
			fi
			### End Test Changes ### }}}

			### Find Branch ### {{{
			local GBra="$(echo ${GStat} | tr ':' '\n' | grep "^##" | cut -c4- | grep -o "^[a-zA-Z]\{1,\}[^\.]")"
			if [ "$GBra" ]; then
				if [ "$GBra" == "master" ]; then
					local GBra="M"			# Because why waste space
				fi
			  else
				local GBra="ERROR"			# It could happen supposedly?
			fi
			### End Branch ### }}}

			PS1+="${GitCol}[$GBra]${RCol}"	# Add result to prompt

			### Find Commit Status ### {{{
				## Test Modified and Untracked for "0"
#					# local GDel="$(echo ${GStat} | tr ':' '\n' | grep -c "^[ MARC]D")"

			local GAhe="$(echo ${GStat} | tr ':' '\n' | grep "^##" | grep -o "ahead [0-9]\{1,\}" | grep -o "[0-9]\{1,\}")"
			if [ "$GAhe" ]; then
				PS1+="${Gre}↑${RCol}${GAhe}"	# Ahead
			fi

			## Needs a `git fetch`
			local GBeh="$(echo ${GStat} | tr ':' '\n' | grep "^##" | grep -o "behind [0-9]\{1,\}" | grep -o "[0-9]\{1,\}")"
			if [ "$GBeh" ]; then
				PS1+="${Red}↓${RCol}${GBeh}"	# Behind
			fi

			local GMod="$(echo ${GStat} | tr ':' '\n' | grep -c "^[ MARC]M")"
			if [ "$GMod" -gt "0" ]; then
				PS1+="${Pur}≠${RCol}${GMod}"	# Modified
			fi

			local GUnt="$(echo ${GStat} | tr ':' '\n' | grep -c "^?")"
			if [ "$GUnt" -gt "0" ]; then
				PS1+="${Yel}?${RCol}${GUnt}"	# Untracked
			fi
			### End Commit Status ### }}}
			
			echo "${PS1}"
		fi
}


# Git
# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]; then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

# get activated Python VirtualENV
function parse_python_venv {
	if [ ! -z "${VIRTUAL_ENV_PROMPT}" ]; then
		echo "$VIRTUAL_ENV_PROMPT"
	fi
}
