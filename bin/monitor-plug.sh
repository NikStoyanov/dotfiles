#!/bin/bash

read STATUS_DP < /sys/class/drm/card0-DP-1/status
read STATUS_DP2 < /sys/class/drm/card0-DP-2/status
read STATUS_HDMI < /sys/class/drm/card0-HDMI-A-1/status
read STATUS_HDMI2 < /sys/class/drm/card0-HDMI-A-2/status
export DISPLAY=:0

DEV=""
DEVC=""
STATUS="disconnected"
if [[ "$STATUS_DP" = "connected" ]]; then
	STATUS="conected"
	DEV="DP-1"
	DEVC="DP-1"
elif [[ "$STATUS_DP2" = "connected" ]]; then
	STATUS="conected"
	DEV="DP-2"
	DEVC="DP-2"
elif [[ "$STATUS_HDMI" = "connected" ]]; then
	STATUS="connected"
	DEV="HDMI-1"
	DEVC="HDMI-A-1"
elif [[ "$STATUS_HDMI2" = "connected" ]]; then
	STATUS="connected"
	DEV="HDMI-2"
	DEVC="HDMI-A-2"
fi

dpi=96
if [ "$STATUS" = "disconnected" ]; then
	/usr/bin/xrandr --output DP-1 --off
	/usr/bin/xrandr --output DP-2 --off
	/usr/bin/xrandr --output HDMI-1 --off
	/usr/bin/xrandr --output HDMI-2 --off
	/usr/bin/xrandr --output eDP-1 --mode 1366x768
	/usr/bin/xrandr --output eDP-1 --auto
	/usr/bin/xset +dpms
	/usr/bin/xset s default
	dpi=144
else
	if [[ $1 == "mirror" ]]; then
		/usr/bin/xrandr --output $DEV --mode 1024x768
		/usr/bin/xrandr --output eDP-1 --mode 1024x768 --same-as $DEV
	elif [[ $1 == "single" ]]; then
		/usr/bin/xrandr --output eDP-1 --off
		/usr/bin/xrandr --output $DEV --mode 1920x1080
	else
		edid=$(/usr/bin/cat /sys/class/drm/card0-$DEVC/edid | /usr/bin/sha512sum - | /usr/bin/sed 's/\s*-$//')

		laptop_res="1366x768"
		pos="primary --rotate normal --left-of"

		case "$edid" in
			"82bbccd669dc0773604295b051d8339382d8544cab289ec0a4b3fe874d8d5796590fcf46a9ef8b1dc5755b0c0f07806d0c975fc2b755356eedc5720b48a2ba57")
				;;
		esac

		/usr/bin/xrandr --output eDP-1 --mode "$laptop_res" --output $DEV --$pos eDP-1 --auto
		sleep 1
	fi
fi

~/.config/polybar/launch.sh
