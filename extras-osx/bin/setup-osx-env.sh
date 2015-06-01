#!/bin/sh
# This script does bad things to OSX!

# Get rid of the desktop
if [ "$(defaults read com.apple.finder CreateDesktop)" = "true" ]; then
    defaults write com.apple.finder CreateDesktop false

    echo "* Desktop killed. You should run:"
    echo "      killall finder"
    echo "  when you get a chance."
fi
