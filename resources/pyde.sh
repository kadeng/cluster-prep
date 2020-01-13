!/bin/bash
export EDITOR=ne
export TMUX_SESSION=$1
tmux has-session -t "$TMUX_SESSION"
if [ $? -eq 0 ]
then
  echo "Attaching to existing session $TMUX_SESSION"
  tmux attach-session -t "$TMUX_SESSION"
else
  # bash --init-file <(echo "ls; pwd")
  echo "Creating new pyde session $TMUX_SESSION"
  tmux -f /usr/local/cluster-prep/resources/tmux.conf new-session -d -s "$TMUX_SESSION" "bash --init-file <(echo ranger)"
  tmux split-window -v 'bash --init-file <(echo ptipython)'
  tmux split-window -h -p 35 'bash'
  tmux -2 attach-session -d
fi