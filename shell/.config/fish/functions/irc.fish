# Defined in - @ line 1
function irc --description 'alias irc tmux -f ~/.config/tmux/tmux.conf -L weechat attach -d'
	tmux -f ~/.config/tmux/tmux.conf -L weechat attach -d $argv;
end
