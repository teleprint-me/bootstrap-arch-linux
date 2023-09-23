### WiFi Troubleshooting for MT7921e/MT7922 on Arch Linux

#### Preliminary Steps:

1. **Update System and Firmware**: Ensure your system and `linux-firmware`
   package are up-to-date.

   ```bash
   sudo pacman -Syu linux-firmware
   ```

2. **Reboot**: Restart your system to apply updates.

#### Diagnostic Commands:

- **Module Status**: Check if the `mt7921e` module is loaded.

  ```bash
  lsmod | grep mt7921e
  ```

- **System Logs**: Look for error messages related to the WiFi module.

  ```bash
  dmesg | grep -i 'mt79'
  ```

#### Troubleshooting Steps:

1. **Reload Module**: Unload and reload the `mt7921e` kernel module.

   ```bash
   sudo modprobe -r mt7921e
   sudo modprobe mt7921e
   ```

2. **Check Firmware**: Verify the presence of necessary firmware files.

   ```bash
   ls /lib/firmware/ | grep mt7921e
   ```

3. **Network Status**: Examine and manually bring up the network interface if
   needed.

   ```bash
   ip link set wlan0 up
   ```

4. **Additional Logs**: Use `journalctl` for more detailed information.

   ```bash
   journalctl -xe | grep mt7921e
   ```

#### Last Resort:

- **Blacklist Conflicts**: If you've identified a specific conflicting module
  like `wl`, consider blacklisting it as a last resort.

  ```bash
  echo "blacklist wl" | sudo tee /etc/modprobe.d/blacklist-wl.conf
  ```

#### Notes:

- The error `driver own failed` and code `-5` suggest a driver or firmware
  issue.
- If the issue persists, consider reporting it as it may be a driver bug.
