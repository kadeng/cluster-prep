!/bin/bash
tmux new-session -d "bash"
tmux split-window -v 'ptipython'
tmux split-window -h 'bash'
tmux -2 attach-session -d
