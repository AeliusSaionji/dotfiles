if status is-interactive
and not set -q TMUX
and not set -q OS
  if tmux has-session -t home
    exec tmux attach-session -t home
  else
    tmux new-session -s home
  end
end
