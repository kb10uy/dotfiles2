# Load interactive environments and completions
source /home/kb10uy/.phpbrew/phpbrew.fish

# Interactive operation settings
set -x GPG_TTY (tty)
if [ -n "$SSH_CONNECTION" ]
  set -x PINENTRY_USER_DATA 'USE_CURSES=1'
end

# Set host color
set ract_host_bg EE4466
set ract_host_fg 442211
