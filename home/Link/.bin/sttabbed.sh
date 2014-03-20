#!/usr/bin/env bash
[[ -z $((xprop -id $(</tmp/tabbed.xid)) 2>/dev/null) ]] && tabbed -n term -cd > /tmp/tabbed.xid 
exec st -w $(</tmp/tabbed.xid) &
