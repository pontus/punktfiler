# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022


alias julia='julia --color=no'
alias jävel=git

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

hname=`hostname -s`

case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='logsbeforenext; echo -ne "\033]0;${USER}@${hname}: ${PWD/$HOME/~}\007"'
    ;;
screen*)
    PROMPT_COMMAND='logsbeforenext; echo -n -e "\\033k${hname}\033\\"'	
    ;;
esac

export PROMPT_COMMAND

PS1='\u@\h:\w\$ '


# Handle machines without screen
infocmp 2>/dev/null >/dev/null || TERM=vt100

# Completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Use our pythonconfiguration
PYTHONSTARTUP=$HOME/.pythonrc
export PYTHONSTARTUP

PATH=$PATH:/usr/sbin:/sbin

if [ -r "$HOME/.bashrc.local" ]; then
  . "$HOME/.bashrc.local"
fi

if [ "x$USER" = "x" ]; then
  USER=`id -nu`
fi

# SSH-agent fix. Note possible security issues
MYSOCKPATH="/tmp/.agent.$USER.$UID"

if SSH_AUTH_SOCK="$MYSOCKPATH" ssh-add -L 2>/dev/null >/dev/null || \
   LANG=C SSH_AUTH_SOCK="$MYSOCKPATH" ssh-add -L 2>&1 | grep -F -q \
   'The agent has no identities.'; then
  # Our link works fine
  :
else
  # Link doesn't work, check if we've got an agent (SSH_AUTH_SOCK).

  if ssh-add -L 2>/dev/null >/dev/null; then
    # We've got a working agent.
      rm -f "$MYSOCKPATH"
      ln -s "$SSH_AUTH_SOCK" "$MYSOCKPATH"
  else 
     # Agent broken? 
     if ssh-add -L 2>/dev/null | fgrep -q 'agent has no identities'; then 
       : # All is well
     else
       AGPATH="/tmp/.ssh_agent.$$.$UID"
       rm -f "$AGPATH" 
       ssh-agent -a "$AGPATH" >/dev/null
       rm -f "$MYSOCKPATH"
       ln -s "$AGPATH" "$MYSOCKPATH"
     fi 
  fi
fi

SSH_AUTH_SOCK="$MYSOCKPATH"
export SSH_AUTH_SOCK


if type -t ls | grep -q alias ; then
  unalias ls
fi


if [ -x /usr/local/bin/tmux ]; then
  alias tmux=/usr/local/bin/tmux
fi


svn-log-diff()
 {
        for c in `svn log "$@"  | grep '^r' | cut -f1 -d ' ' | sed s/r/-c/`; do
             svn diff --force $c || break
        done
 }

for p in ~/.gem ~/.gem/ruby/* ~/.local; do
  if [ -d "$p/bin" ]; then
    PATH=$PATH:$p/bin
  fi
done

HISTTIMEFORMAT='%F %T '
HISTIGNORE='bg:fg:history:exit'
shopt -s histappend
HISTFILESIZE=1000000
HISTSIZE=1000000
HISTCONTROL=
shopt -s cmdhist

logsbeforenext () {
  history -a
  nowhistory=$(printf '%(%s)T')
  find ~/.bash_history.d/ -mmin "-$(((nowhistory-lasthistory)/60+2))" |  while read -r p; do
    history -n "$p"
  done
  lasthistory=$nowhistory
}

trap logsbeforenext EXIT
trap logsbeforenext DEBUG
lasthistory=$(printf '%(%s)T')
now=$(printf '%(%Y%m%d-%H%M%S)T')
HISTFILE="$HOME/.bash_history.d/$now-$hname-$$"

DOCKER_COMPLETION_SHOW_CONTAINER_IDS=yes

for p in ~/.bash_history ~/.bash_history.d/*; do
    history -n "$p"
done

if [ -f ~/.bashrc_local ]; then
. ~/.bashrc_local
fi

for tool in kubectl; do
  eval "$($tool completion bash)"
done
