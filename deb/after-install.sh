#!/bin/sh

udevadm control --reload-rules
udevadm trigger

echo "reloaded udev rules"
