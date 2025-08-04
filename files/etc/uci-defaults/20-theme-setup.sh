#!/bin/sh

# Set Argon as the default theme for LuCI
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci

# Clean up the script itself after execution
rm -- "$0"

exit 0