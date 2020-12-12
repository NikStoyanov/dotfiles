abbr -a m make
abbr -a g git
abbr -a gah 'git stash; and git pull --rebase; and git stash pop'
abbr -a vimdiff 'nvim -d'
abbr -a vim 'nvim'
abbr -a vi 'nvim'
abbr -a cat 'bat'

set -U fish_user_paths /usr/local/sbin /usr/local/bin /usr/bin /bin

if status --is-interactive
	tmux ^ /dev/null; and exec true
end

# Weather
function weather
	curl -s wttr.in/$argv[1]
end

function fish_prompt
	set_color brblack
	echo -n "["(date "+%H:%M")"] "
	set_color blue
	echo -n (hostname)
	if [ $PWD != $HOME ]
		set_color brblack
		echo -n ':'
		set_color yellow
		echo -n (basename $PWD)
	end

	if set -q VIRTUAL_ENV
		set_color magenta
		echo -n -s " [" (basename "$VIRTUAL_ENV") "]" (set_color normal)
	end

	set_color green
	printf '%s ' (__fish_git_prompt)
	set_color red
	echo -n '| '
	set_color normal
end

if command -v exa > /dev/null
	abbr -a l 'exa'
	abbr -a ls 'exa'
	abbr -a ll 'exa -l'
	abbr -a lll 'exa -la'
else
	abbr -a l 'ls'
	abbr -a ll 'ls -l'
	abbr -a lll 'ls -la'
end

if test -f /usr/share/autojump/autojump.fish;
	source /usr/share/autojump/autojump.fish;
end

function fish_greeting
	echo
	echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e " \\e[1mDisk usage:\\e[0m"
	echo
	echo -ne (\
		df -l -h | grep -E 'dev/(xvda|sd|mapper)' | \
		awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
		sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
		paste -sd ''\
	)
	echo

	echo -e " \\e[1mNetwork:\\e[0m"
	echo
	# http://tdt.rocks/linux_network_interface_naming.html
	echo -ne (\
		ip addr show up scope global | \
			grep -E ': <|inet' | \
			sed \
				-e 's/^[[:digit:]]\+: //' \
				-e 's/: <.*//' \
				-e 's/.*inet[[:digit:]]* //' \
				-e 's/\/.*//'| \
			awk 'BEGIN {i=""} /\.|:/ {print i" "$0"\\\n"; next} // {i = $0}' | \
			# public addresses are underlined for visibility \
			sed 's/ \([^ ]\+\)$/ \\\e[4m\1/' | \
			# private addresses are not \
			sed 's/m\(\(10\.\|172\.\(1[6-9]\|2[0-9]\|3[01]\)\|192\.168\.\).*\)/m\\\e[24m\1/' | \
			# unknown interfaces are cyan \
			sed 's/^\( *[^ ]\+\)/\\\e[36m\1/' | \
			# ethernet interfaces are normal \
			sed 's/\(\(en\|em\|eth\)[^ ]* .*\)/\\\e[39m\1/' | \
			# wireless interfaces are purple \
			sed 's/\(wl[^ ]* .*\)/\\\e[35m\1/' | \
			# wwan interfaces are yellow \
			sed 's/\(ww[^ ]* .*\).*/\\\e[33m\1/' | \
			sed 's/$/\\\e[0m/' | \
			sed 's/^/\t/' \
		)
	echo

	if test -s ~/todo
		set_color red
		cat ~/todo | sed 's/^/ /'
		echo
	end

	set_color normal
end

# External IP address into clipboard
function myip
	curl ifconfig.me | xclip -selection c
end

# Fish should not add things to clipboard when killing
# See https://github.com/fish-shell/fish-shell/issues/772
set FISH_CLIPBOARD_CMD "cat"

# Go
set PATH $PATH /opt/go1.14/bin/
set GOPATH $GOPATH $HOME/go
set PATH $PATH $GOPATH/bin/

# Julia
abbr -a jl1.3 /opt/julia-1.3.1/bin/julia
abbr -a jl /opt/julia-1.5.1/bin/julia
abbr -a julia /opt/julia-1.5.1/bin/julia

# Gmsh
set PATH $PATH $HOME/Documents/gmsh/gmsh-4.2.2-Linux64/bin/

# Emacs
set PATH $PATH $HOME/git/emacs/src/

# Exa
set PATH $PATH /opt/exa/target/release/

# Custom bin scripts
set PATH $PATH $HOME/bin/

# Fish virtualenv
eval (python3 -m virtualfish)

# Python, vim, virtualfish
# https://vi.stackexchange.com/questions/7644/
if test -e $VIRTUAL_ENV
	vf activate $VIRTUAL_ENV/bin/activate.fish
end

# Setup python versions
set -Ux PYENV_ROOT $HOME/.pyenv
set -Ux fish_user_paths $PYENV_ROOT/bin $fish_user_paths

# Fish git prompt
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3

# colored man output
# from http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
setenv LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
setenv LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
setenv LESS_TERMCAP_me \e'[0m'           # end mode
setenv LESS_TERMCAP_se \e'[0m'           # end standout-mode
setenv LESS_TERMCAP_so \e'[38;5;246m'    # begin standout-mode - info box
setenv LESS_TERMCAP_ue \e'[0m'           # end underline
setenv LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline

# Setup ruby
# https://rvm.io/integration/fish
rvm default
