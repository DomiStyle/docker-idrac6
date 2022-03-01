#!/bin/bash

# Wait for iDRAC to load
sleep 15s

# Click "Virtual Media"
xdotool mousemove 10 10 click 1
sleep 1s

# Click "Launch Virtual Media"
xdotool mousemove 10 30 click 1
sleep 3s

# Click "Add Image"
xdotool mousemove 500 80 click 1
sleep 1s

# Get image from $VIRTUAL_ISO var
xdotool type "/vmedia/$VIRTUAL_ISO"
xdotool key Return
sleep 1s

# Map image
xdotool mousemove 56 63 click 1