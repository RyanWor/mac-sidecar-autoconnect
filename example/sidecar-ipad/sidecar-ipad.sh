#!/bin/bash
# Wait briefly for the iPad to finish initialising its USB connection
sleep 3

CONFIG="$HOME/.config/sidecar-devices"
[[ -f "$CONFIG" ]] || exit 0

# Get serials of all connected iPad USB nodes, match against config.
# Using -n "iPad" scopes ioreg to iPad device nodes only, avoiding false
# matches from other Apple USB devices (e.g. iPhone, accessories).
while IFS= read -r serial; do
    device=$(grep -v '^#' "$CONFIG" | grep "^${serial}=" | cut -d'=' -f2-)
    if [[ -n "$device" ]]; then
        /usr/local/bin/sidecarlauncher connect "$device" -wired
        exit $?
    fi
done < <(ioreg -p IOUSB -l -n "iPad" | grep '"USB Serial Number"' | sed 's/.*= "\(.*\)"/\1/')
