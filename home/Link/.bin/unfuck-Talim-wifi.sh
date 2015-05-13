#!/bin/sh
rfkn=$(rfkill list | grep phy0 | colrm 2)
rfkill unblock $rfkn
rfkn=$(rfkill list | grep hp-wifi | colrm 2)
rfkill unblock $rfkn
