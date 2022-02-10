# .bash_files

# Setup gpg agent info 
# if not running, set one up

GPG_AGENT_INFO="${HOME}/.gpg-agent-info"

if [ -f "${GPG_AGENT_INFO}" ]; then
	source "${GPG_AGENT_INFO}"
	export GPG_AGENT_INFO
	export SSH_AUTH_SOCK
	export SSH_AGENT_PID
else
	/usr/bin/gpg-agent --daemon --write-env-file "${GPG_AGENT_INFO}"
fi
