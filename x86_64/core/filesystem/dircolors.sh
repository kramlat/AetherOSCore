# Setup for /bin/ls and /bin/grep to support color, the alias is in /etc/bashrc.

#first check for what color depth TERM gives us (8,256, or not supported)
if [ -f "/etc/dircolors" ] ; then
	case $(tput colors) in
		8)
			#8 colors and 8 bright colors
			export COLOR=4
			;;
		256)
			#256 color mode
			export COLOR=8
			;;
		*)
			#assume no color
			export COLOR=1
			;;
	esac
fi

#first check for full color
if [ "$COLORTERM" == "truecolor" ] ; then
	export COLOR=24
fi

#second check for full color
if [ "$COLORTERM" == "24bit" ] ; then
        export COLOR=24
fi

#what color depth is actually supported?
case $COLOR in
	8)
		#we have a 256 color terminal, yippie!
		eval $(dircolors -b /etc/dircolors)
		NORMAL="\[\e[0m\]"
		RED="\[\e[00;38;5;125m\]"  
		WHITE="\[\e[00;38;5;231m\]"
		GREEN="\[\e[00;38;5;112m\]"
		export GREP_COLOR=$RED
		alias ls='ls --color=always -h'
		alias grep='grep --color=auto'
		;;
	4)
		#8 colors, and 8 bright colors, at least we have color
		eval $(dircolors -b /etc/dircolors-256)
		NORMAL="\[\e[0m\]"
		RED="\[\e[01;31m\]"
		WHITE="\[\e[01;37m\]"
		GREEN="\[\e[01;32m\]"
		export GREP_COLOR=$RED
		alias ls='ls --color=always -h'
		alias grep='grep --color=auto'
		;;
	24)
		#wow! we have a full color terminal here!
		eval $(dircolors -b /etc/dircolors-full)
		NORMAL="\[\e[0m\]"
                RED="\[\e[01;38;2;126;105;144m\]"
                WHITE="\[\e[01;38;2;255;255;255m\]"
                GREEN="\[\e[01;38;2;0;255;0m\]"
		export GREP_COLOR=$RED
		alias ls='ls --color=always -h'
		alias grep='grep --color=auto'
		;;
	*)
		#oh no! unsupported terminal, so no color
		NORMAL=""
		RED=""
		WHITE=""
		GREEN=""
		alias ls='ls -h'
		;;
esac

unset COLOR
#load your own custom dircolors script
if [ -f "$HOME/.dircolors" ] ; then
        eval $(dircolors -b $HOME/.dircolors)
fi
