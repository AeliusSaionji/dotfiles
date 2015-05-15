#!/bin/sh
is_rotated=$(xrandr | sed -e '/LVDS1/!d')
if [ "$is_rotated" = "LVDS1 connected 1280x800+0+0 (normal left inverted right x axis y axis) 261mm x 163mm" ]; then
	xrandr --output LVDS1 --rotate right
	xinput --set-prop 'Wacom Serial Penabled 1FG Touchscreen stylus' --type=float 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1
	xinput --set-prop 'Wacom Serial Penabled 1FG Touchscreen eraser' --type=float 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1
	xinput --set-prop 'Wacom Serial Penabled 1FG Touchscreen touch' --type=float 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1
	echo right
else
	xrandr --output LVDS1 --rotate normal
	xinput --set-prop 'Wacom Serial Penabled 1FG Touchscreen stylus' --type=float 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1
	xinput --set-prop 'Wacom Serial Penabled 1FG Touchscreen eraser' --type=float 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1
	xinput --set-prop 'Wacom Serial Penabled 1FG Touchscreen touch' --type=float 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1
	echo normal
fi

#rotate left
#xrandr --output LVDS1 --rotate left;xinput --set-prop 'Wacom Serial Penabled 1FG Touchscreen stylus' --type=float 'Coordinate Transformation Matrix' 0 -1 1 1 0 0 0 0 1
#xrandr --output LVDS1 --rotate left;xinput --set-prop 'Wacom Serial Penabled 1FG Touchscreen eraser' --type=float 'Coordinate Transformation Matrix' 0 -1 1 1 0 0 0 0 1
#xrandr --output LVDS1 --rotate left;xinput --set-prop 'Wacom Serial Penabled 1FG Touchscreen touch' --type=float 'Coordinate Transformation Matrix' 0 -1 1 1 0 0 0 0 1
#rotate flip
#xrandr --output LVDS1 --rotate inverted;xinput --set-prop 'Wacom Serial Penabled 1FG Touchscreen stylus' --type=float 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1
#xrandr --output LVDS1 --rotate inverted;xinput --set-prop 'Wacom Serial Penabled 1FG Touchscreen eraser' --type=float 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1
#xrandr --output LVDS1 --rotate inverted;xinput --set-prop 'Wacom Serial Penabled 1FG Touchscreen touch' --type=float 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1
