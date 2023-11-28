# Calculate how many characters a string takes up in prompt (accounts
# for escaping & wide characters)
function promptLength () {
    # Use default zsh options
    emulate -L zsh
    # Set columns to be either the second argument or environment variable
    local -i COLUMNS=${2:-COLUMNS}
    # Initialize l & m to 0, initialize u to be length of first argument (including escapes)
    local -i l m u=${#1}
    # If u is non-zero
    if (( u )); then
        # http://zsh.zle.lc/zsh-conditional-substrings-prompts.html
	# https://zsh.sourceforge.io/Doc/Release/Expansion.html (look at section 14.3.1 for explanation of ${(%):-""})
	# While length of $1 (after escaping) is less than u
        # Note: there is nothing before :- therefore what comes after it is ALWAYS substituted
        # Note: $1%$u(l.1.0) appends 1 if length of $1 is greater than u, else 0
	# Note: the [-1] index gets the last character of the string (the 1/0 that was appended)
	# After this while loop, l is smaller than length of $1 (after escaping), and u is larger
        while (( ${${(%):-$1%$u(l.1.0)}[-1]} )); do
            l=u
            (( u *= 2 ))
        done
        # While u is larger than l + 1
        # Note: because of the last while loop, it is guaranteed that
        # l is < p_len($1) and u > p_len($1) on the first iteration
        while (( u > l + 1 )); do
            (( m = l + ( (u-l) / 2 ) ))
            # l = m if p_len($1) >= $m, else u = m
            (( ${${(%):-$1%$m(l.l.u)}[-1]} = m ))
        done
    fi
    # Once u = l + 1, p_len($1) = $l
    typeset -g RETURN=$l
}

# Add padding characters between top_left and top_right prompts
function padMiddle () {
    # Use default zsh options
    emulate -L zsh

    # Get prompt length of top_left
    promptLength $1
    local -i left_length=$RETURN
    # Get prompt length of top_right
    promptLength $2
    local -i right_length=$RETURN
    # Calculate pad length
    local -i pad_length=$((COLUMNS - left_length - right_length - ${ZLE_RPROMPT_INDENT:-1}))
    if (( pad_length < 1 )); then
        # Not enough space for right side, drop it
        typeset -g RETURN=$1
    else
        # Repeat padding #pad_length number of times
        local pad=${(pl:$pad_length::─:)}
        # Return arguments with padding in between
        typeset -g RETURN=$1${pad}$2
    fi
}

function sshPromptUpdate () {
    # Use default zsh options
    emulate -L zsh

    # Initialize ssh prompt
    typeset -g SSH_PROMPT=''

    # Set prompt for ssh sessions
    if [[ "${SSH_TTY}" ]]; then
	    SSH_PROMPT="(ssh)-"
    fi
}

function venvPromptUpdate () {
    # Use default zsh options
    emulate -L zsh

    # Initialize venv prompt
    typeset -g VENV_PROMPT=''

    # Set prompt for conda
    if [[ "${CONDA_DEFAULT_ENV}" ]]; then
	    VENV_PROMPT="(${CONDA_DEFAULT_ENV})-"
    fi

    # Set prompt for virtual environments
    if [[ "${VIRTUAL_ENV}" ]]; then
	    VENV_PROMPT="(${VIRTUAL_ENV})-"
    fi
}

function abducoPromptUpdate () {
    # Use default zsh options
    emulate -L zsh

    # Initialize venv prompt
    typeset -g ABDUCO_PROMPT=''

    # Set prompt for virtual environments
    if [[ "${ABDUCO_SESSION}" ]]; then
	    ABDUCO_PROMPT=" %B${ABDUCO_SESSION}%b "
    fi
}

# Start instance of gitstatusd plugin to allow for querying
gitstatus_stop 'GS' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'GS'

# Get git information for prompt
function gitstatusPromptUpdate () {
    # Use default zsh options
    emulate -L zsh

    # Initialize git prompt
    typeset -g GITSTATUS_PROMPT=''

    # Call gitstatus_query synchronously
    gitstatus_query 'GS'                  || return 1  # error
    [[ $VCS_STATUS_RESULT == 'ok-sync' ]] || return 0  # not a git repo

    local g='%F{142}'   # green foreground
    local y='%F{220}'   # yellow foreground
    local b='%F{152}'   # blue foreground
    local r='%F{174}'   # red foreground

    # Initialize temporary git prompt holder
    local p
    local branch_color="$PROMPT_COLOR_BRANCH"

    # Determine location of HEAD
    local where  # branch name, tag or commit
    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
        where=$VCS_STATUS_LOCAL_BRANCH
    elif [[ -n $VCS_STATUS_TAG ]]; then
        p+='%f#'
        where=$VCS_STATUS_TAG
    else
        p+='%f@'
        where=${VCS_STATUS_COMMIT[1,8]}
    fi

    (( $#where > 32 )) && where[13,-13]="…" # truncate long branch names and tags
    p+="${branch_color}[${clean}${where//\%/%%}"     # escape %

    # $ if have stashes.
    (( VCS_STATUS_STASHES        )) && p+=" ${g}$"
    # ? if have untracked files.
    (( VCS_STATUS_NUM_UNTRACKED  )) && p+=" ${r}?"
    # + if have unstaged changes.
    (( VCS_STATUS_NUM_UNSTAGED   )) && p+=" ${y}-"
    # ! if have staged changes.
    (( VCS_STATUS_NUM_STAGED     )) && p+=" ${g}+"
    # ⇣ if behind the remote.
    (( VCS_STATUS_COMMITS_BEHIND )) && p+=" ${b}⇣"
    # ⇡ if ahead of the remote; no leading space if also behind the remote: ⇣⇡.
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && p+=" "
    (( VCS_STATUS_COMMITS_AHEAD  )) && p+="${b}⇡"
    # ⇠ if behind the push remote.
    (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" ${b}⇠"
    (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" "
    # ⇢ if ahead of the push remote; no leading space if also behind: ⇠⇢.
    (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && p+="${b}⇢"
    # ~ if have merge conflicts.
    (( VCS_STATUS_NUM_CONFLICTED )) && p+=" ${r}~"
    # 'merge' if the repo is in an unusual state.
    [[ -n $VCS_STATUS_ACTION     ]] && p+=" ${r}${VCS_STATUS_ACTION}"

    GITSTATUS_PROMPT="-${p}${branch_color}]%f"
}

PROMPT_COLOR_USER='%F{blue}'
PROMPT_COLOR_PATH='%F{cyan}'
PROMPT_COLOR_BRANCH='%F{magenta}'

function setPrompt () {
    # Use default zsh options
    emulate -L zsh

    # Update ssh status
    sshPromptUpdate

    # Update venv status
    venvPromptUpdate

    # Update abduco session status
    abducoPromptUpdate

    # Get git information
    gitstatusPromptUpdate

    # Set prompt information
    local default_color='%F{white}'
    local user_color="$PROMPT_COLOR_USER"
    local path_color="$PROMPT_COLOR_PATH"

    local top_left=$'\n'"%f╭─${SSH_PROMPT}${VENV_PROMPT}${user_color}(%(!.%F{196}.)%n%(!.${user_color}.) @ %m)%f-${path_color}[%~]%f${GITSTATUS_PROMPT}%f"
    local top_right="${ABDUCO_PROMPT}%f─╮"
    local bottom_left="%f╰─ ᛋ "
    local bottom_right="%F{green}󰟠%f ─╯"

    # Call padMiddle to set RETURN
    padMiddle "$top_left" "$top_right"

    # Set prompt
    PROMPT=$RETURN$'\n'$bottom_left
    RPROMPT=$bottom_right
}

# Set prompt shell options
setopt no_prompt_{bang,subst} prompt_{cr,percent,sp}
# Add hook function (call setPrompt before each new prompt)
autoload -Uz add-zsh-hook
add-zsh-hook precmd setPrompt

function setTransientPrompt () {
    local default_color='%F{white}'
    local user_color="$PROMPT_COLOR_USER"
    local path_color="$PROMPT_COLOR_PATH"
    local branch_color="$PROMPT_COLOR_BRANCH"

    # PROMPT=$'\n'"${default_color}» ${user_color}(%(!.%F{196}.)%n%(!.${user_color}.) @ %m)${default_color}-${path_color}[%~]${default_color} ᛋ "
    PROMPT=$'\n'"%f╭─${SSH_PROMPT}${VENV_PROMPT}${user_color}(%(!.%F{196}.)%n%(!.${user_color}.) @ %m)%f-${path_color}[%~]${branch_color}${GITSTATUS_PROMPT}%f"$'\n'"%f╰─ ᛋ "
    RPROMPT=''
}

# Transient prompt (change current prompt before each new prompt)
zle-line-finish() {
    setTransientPrompt
    zle reset-prompt
}
zle -N zle-line-finish

# Transient prompt upon interrupt (change current prompt before abort signal)
# Programs terminated by uncaught signals typically return the status 128 plus the signal number
# Hence the following causes the handler for SIGINT to change the prompt, then mimic the usual effect of the signal
# https://zsh.sourceforge.io/Doc/Release/Functions.html#Trap-Functions
TRAPINT () {
	setTransientPrompt
	zle reset-prompt 2> /dev/null
	setPrompt
	return $(( 128 + $1 ))
}

# Recalculate current prompt after window resize
TRAPWINCH () {
	setPrompt
	zle reset-prompt
}
