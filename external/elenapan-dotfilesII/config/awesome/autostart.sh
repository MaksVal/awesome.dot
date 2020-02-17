/#!/usr/bin/env bash
# ---
# Use "run program" to run it only if it is not already running
# Use "program &" to run it regardless
# ---
# NOTE: This script runs with every restart of AwesomeWM
# TODO: run_once

function run {
    if ! pgrep -f $1 > /dev/null ;
    then
        $@&
    fi
}

# Music
run mpd ~/.config/mpd/mpd.conf
#run mopidy > ~/.cache/mopidy/mopidy.log 2>&1

# Emacs daemon
#run emacs --daemon

# Load terminal colorscheme and settings
#xrdb ~/.Xresources

# Urxvt daemon
#run urxvtd -q -o -f

# Mpv input file
#mkfifo /tmp/mpv.fifo

# For desktop effects
#run compton --config ~/.config/compton/compton.conf

# Enable numlock on login
#run numlockx

# Run xscreensaver
run xscreensaver -nosplash
# For battery notifications
# run xfce4-power-manager

# Network manager tray icon
#run nm-applet

# Keyboard
#setxkbmap -layout "us,gr" -option "grp:alt_shift_toggle"
#setxkbmap -layout "us,gr,ru" -option "grp:alt_shift_toggle"

# Caps Lock is Escape (Escape remains as is)
# setxkbmap -option caps:escape

# Kill redshift processes
# pkill redshift

# Scratchpad
#scratchpad

# Gnome Services
run /usr/lib/goa-daemon
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
eval $(gnome-keyring-daemon --components=pkcs11,secrets,ssh -r &)
export SSH_AUTH_SOCK
export GNOME_KEYRING_CONTROL

# Update battery status and send signals
CHARGING="$(udevadm info --path=/sys/class/power_supply/BAT0 | grep POWER_SUPPLY_STATUS | grep Charging)"
if [ ${#CHARGING} -eq "0" ]; then
    AWESOME_SIGNAL="charger_unplugged"
else
    AWESOME_SIGNAL="charger_plugged"
fi
awesome-client "awesome.emit_signal(\"$AWESOME_SIGNAL\")"
