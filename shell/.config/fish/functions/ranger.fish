function ranger
	if test -z "$RANGER_LEVEL"
		/usr/bin/ranger $argv
	else
		exit
	end
end
