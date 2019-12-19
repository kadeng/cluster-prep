!/bin/bash
export EDITOR=ne
export TMUX_SESSION=$1
tmux has-session -t "$TMUX_SESSION"
if [ $? -eq 0 ]
then
  echo "Attaching to existing session $TMUX_SESSION"
  tmux attach-session -t "$TMUX_SESSION"
else
  echo "Creating new pide session $TMUX_SESSION"
  tmux -f /usr/local/cluster-prep/resources/tmux.conf new-session -d -s "$TMUX_SESSION" "bash"
  tmux split-window -v 'bash'
  tmux split-window -h -p 35 'bash'
  tmux -2 attach-session -d
fi