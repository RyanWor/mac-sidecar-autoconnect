[![Compile Handler](https://github.com/himbeles/mac-device-connect-daemon/actions/workflows/compile.yml/badge.svg)](https://github.com/himbeles/mac-device-connect-daemon/actions/workflows/compile.yml)

# Auto-connect iPad Sidecar on USB plug-in

Automatically launches [Sidecar](https://support.apple.com/en-us/HT210380) when an iPad is connected via USB, using [sidecarlauncher](https://github.com/drdayalpatel/sidecarlauncher). Supports multiple iPads — the correct device is identified by USB serial number so no spurious connection attempts or error popups occur.

This is a fork of [himbeles/mac-device-connect-daemon](https://github.com/himbeles/mac-device-connect-daemon), which uses Apple's `IOKit` library and a LaunchAgent to run a shell script triggered by USB device connection.

---

## Requirements

- [sidecarlauncher](https://github.com/drdayalpatel/sidecarlauncher) installed at `/usr/local/bin/sidecarlauncher`
- `handle-xpc-event-stream` binary — download the latest build artifact from the [Compile Handler action](https://github.com/himbeles/mac-device-connect-daemon/actions/workflows/compile.yml) or build it yourself:
  ```sh
  swift build --configuration release --package-path XPCEventStreamHandler --arch arm64 --arch x86_64
  cp ./XPCEventStreamHandler/.build/apple/Products/Release/handle-xpc-event-stream /usr/local/bin/
  ```

---

## Setup

**1. Find your iPad's USB serial number** — plug it in and run:
```sh
ioreg -p IOUSB -l -n "iPad" | grep '"USB Serial Number"'
```

**2. Create the config file** at `~/.config/sidecar-devices`, with one entry per iPad:
```sh
YOUR_SERIAL_HERE=Your iPad Pro
YOUR_SERIAL_HERE=Your iPad mini
YOUR_SERIAL_HERE=Your iPad Air
```
Use the exact device name that `sidecarlauncher devices` reports.

**3. Install the script and LaunchAgent:**
```sh
sudo cp example/sidecar-ipad/sidecar-ipad.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/sidecar-ipad.sh
cp example/sidecar-ipad/com.sidecaripad.plist ~/Library/LaunchAgents/
```

**4. Load the LaunchAgent:**
```sh
launchctl load ~/Library/LaunchAgents/com.sidecaripad.plist
```

Plug in your iPad — Sidecar will start automatically.

To unload:
```sh
launchctl unload ~/Library/LaunchAgents/com.sidecaripad.plist
```
