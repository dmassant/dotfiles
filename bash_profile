export EDITOR="nano"

[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

### Prompt variable
# Color the hostname
HOSTNAME=`hostname|sed -e 's/\..*$//'`
if [ $HOSTNAME = 'Davids-MBP' ] || [ $HOSTNAME = 'Davids-MBP.local' ] || [ $HOSTNAME = 'davids-mpb' ]; then
    export HOST_COLOR="\[\033[1;35m\]"
elif [ $HOSTNAME = 'didius' ]; then
    export HOST_COLOR="\[\033[1;36m\]"
elif [ $HOSTNAME = 'septimius' ]; then
    export HOST_COLOR="\[\033[1;30m\]"
fi


# Color the colon red & capitalize hostname if root
COLON_COLOR='0m'
#I am [g]root.
if [ ${UID} -eq 0 ]; then
    COLON_COLOR='1;31m'
fi
if [ ${UID} -eq 0 ]; then
    HOSTNAME="`echo $HOSTNAME|tr '[a-z]' '[A-Z]'`"
fi

function build_prompt {
    EXITSTATUS="$?"

    PROMPT="$HOST_COLOR$HOSTNAME\[\033[00m\]\[\e[$COLON_COLOR\]:\[\033[33m\]\w\[\033[00m\]\[\033[01;33m\]\$\[\033[00m\] "

    # Red background if the last command was unhappy
    if [ "${EXITSTATUS}" -eq 0 ]
    then
       PS1="${PROMPT}"
    else
       PS1="\[\033[41m\]${PROMPT}"
    fi

    # Change the titlebar in xterms
    echo -ne "\033]0;${HOSTNAME}:${PWD}\007"

    # Show command in screen
    echo -ne "\033k\033\0134"

    # Write history after every command
    history -a
}
PROMPT_COMMAND=build_prompt

# Prefer symlinks in Autojump
export AUTOJUMP_KEEP_SYMLINKS=1

# System installed extensions
if [ -f /usr/local/etc/bash_completion ]; then
    echo
    . /usr/local/etc/bash_completion
fi
if [ -f /usr/local/etc/profile.d/autojump.sh ]; then
    . /usr/local/etc/profile.d/autojump.sh
fi
# Homebrew installed extensions
if hash brew 2> /dev/null; then
    BREW=`brew --prefix`/bin/brew
    HOMEBREW_GITHUB_API_TOKEN='0e011744f6da031aafe07a62c4385bc2015517f3'
fi
if [ -n "$BREW" ]; then
    # Completion
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi

    # Autojump
    if [ -f `brew --prefix`/etc/profile.d/autojump.bash ]; then
        . `brew --prefix`/etc/profile.d/autojump.bash
    fi
fi

# Figure out what system we are on
if [ `uname` = Darwin ]; then
    export OS_TYPE='macos'
elif [ `uname` = FreeBSD ]; then
    export OS_TYPE='freebsd'
else
    export OS_TYPE='linux'
fi

# Different options for ls depending on system
if [ $OS_TYPE = 'macos' ]; then
    export LS_OPTIONS='-G'
    export PYTHONPATH="$PYTHONPATH:/Library/Python/2.7/site-packages/"
elif [ $OS_TYPE = 'freebsd' ]; then
    export LS_OPTIONS='-G'
elif [ $OS_TYPE = 'linux' ]; then
    # Proably GNU utils
    export LS_OPTIONS='--color=auto'
fi

# Make 'ls' output legible
export LSCOLORS=ExFxCxDxBxegedabagacad

### Capture more history
#"I know I've used that command before, but I can't remember the syntax"
export HISTFILESIZE=500000
export HISTSIZE=500000
shopt -s histappend
# Combine multiline commands into one in historty
shopt -s cmdhist
# Ignore duplicates, ls without options and builtin commands
HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:sl"
# Store a timestamp in the history
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S - '

#########################
##### Basic Aliases #####
#########################
alias ls='ls $LS_OPTIONS'
alias ll="ls -l"
alias lo="ls -o"
alias lh="ls -lh"
alias la="ls -la"
alias sl="ls"
alias l="ls"
alias s="ls"
alias ld="ls -d"
#alias rm="rm -i"    # Make rming a slow and painful process
# Show most recent files at the bottom
alias ltr="ls -ltr"

# smart git calls and easy status check
function g {
if [[ $# > 0 ]]; then
git $@
else
git status --short --branch
fi
}

# Why doesn't everyone have these?
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."

