# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

hname=`hostname -s`

case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${hname}: ${PWD/$HOME/~}\007"'
    ;;
screen*)
    PROMPT_COMMAND='echo -n -e "\\033k${hname}\033\\"'	
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


# SSH-agent fix. Note possible security issues
MYSOCKPATH="/tmp/.agent.$USER.$UID"

if [ -z "$SSH_AUTH_SOCK" ]; then
  if [ ! -S "$(readlink -f "$MYSOCKPATH")" ]; then
   AGPATH="/tmp/.ssh_agent.$$.$UID"
   rm -f "$AGPATH" 
   ssh-agent -a "$AGPATH"
   SSH_AUTH_SOCK="$AGPATH"
  else
   SSH_AUTH_SOCK="$(readlink -f "$MYSOCKPATH")" 
  fi
fi

if [ "$SSH_AUTH_SOCK" != "$(readlink -f "$MYSOCKPATH")" ]; then
  rm -f "$MYSOCKPATH"
  ln -s "$SSH_AUTH_SOCK" "$MYSOCKPATH"
fi

SSH_AUTH_SOCK="$MYSOCKPATH"
export SSH_AUTH_SOCK





