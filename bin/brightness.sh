#!/bin/bash
cur_brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)

step="0.05"
step=$(printf "%.0f" "$(echo "$step * $max_brightness" | bc -l)")

case "$1" in
	+)
		new_brightness=$(echo "$cur_brightness + $step" | bc -l);
		;;
	-)
		new_brightness=$(echo "$cur_brightness - $step" | bc -l);
		;;
	*)
		echo "Usage: $0 +|-"
		exit 1
		;;
esac

if [[ $new_brightness < 0 ]]; then
	new_brightness="0"
fi

if [[ $new_brightness > $max_brightness ]]; then
	new_brightness="$max_brightness"
fi

echo "$cur_brightness -> $new_brightness / $max_brightness"
echo "$new_brightness" | sudo tee /sys/class/backlight/intel_backlight/brightness
