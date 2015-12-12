# sprockets theme - adapted from `dieter` by Dieter Plaetinck

# Dieter's introduction:

# the idea of this theme is to contain a lot of info in a small string, by
# compressing some parts and colorcoding, which bring useful visual cues,
# while limiting the amount of colors and such to keep it easy on the eyes.
# When a command exited >0, the timestamp will be in red and the exit code
# will be on the right edge.
# The exit code visual cues will only display once.
# (i.e. they will be reset, even if you hit enter a few times on empty command prompts)

typeset -A host_repr

# translate hostnames into shortened, colorcoded strings
host_repr=('dieter-ws-a7n8x-arch' "%{$fg_bold[green]%}ws" 'dieter-p4sci-arch' "%{$fg_bold[blue]%}p4")

# local time, color coded by last return code
time_enabled="%(?.%{$fg[green]%}.%{$fg[red]%})%*%{$reset_color%}"
time_disabled="%{$fg[green]%}%*%{$reset_color%}"
time=$time_enabled

# user part, color coded by privileges
local user="%(!.%{$FG[015]%}.%{$FG[012]%})%n"

local at="%{$FG[012]%}@"

# Hostname part.  compressed and colorcoded per host_repr array
# if not found, regular hostname in default color
# local host="%{fg[cyan]%}@${host_repr[$HOST]:-$HOST}%{$reset_color%}"
local host="%m"

local pwd="%{$FG[012]%}%~"

# variable prompt character - stolen from steve losh's prose theme
function prompt_char {
    # git branch >/dev/null 2>/dev/null && echo '±' && return
    # hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '%(!.#.$)'
}

local separator="%{$FG[130]%}::"

local bkg="%{$BG[234]%}"

ZSH_THEME_GIT_PROMPT_PREFIX="${separator} %{$FG[015]%}± %{$FG[012]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$FG[012]%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[010]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[001]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN=""

###################################################

PROMPT='${bkg}${user}${at}${host} ${separator} ${pwd} $(git_prompt_info)%E
%{$reset_color%}$(prompt_char) '

###################################################

# elaborate exitcode on the right when >0
return_code_enabled="%(?..%{$FG[001]%}%? ↵)"
return_code_disabled=
return_code=$return_code_enabled

RPS1='${return_code}'

function accept-line-or-clear-warning () {
	if [[ -z $BUFFER ]]; then
		time=$time_disabled
		return_code=$return_code_disabled
	else
		time=$time_enabled
		return_code=$return_code_enabled
	fi
	zle accept-line
}
zle -N accept-line-or-clear-warning
bindkey '^M' accept-line-or-clear-warning
