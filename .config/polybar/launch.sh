#!/usr/bin/env bash
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done
polybar i3 2>&1 | tee -a /tmp/polybar.log & disown
