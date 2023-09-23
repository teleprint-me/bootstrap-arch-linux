### Reflector Quickstart Guide for Arch Linux with Backup

#### Installation

```bash
sudo pacman -S reflector
```

#### Backup Existing Mirrorlist

Before running Reflector, it's advisable to create a backup of your existing mirrorlist.

```bash
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
```

Creating a backup serves several purposes:

- It prevents accidental overwrites of your current mirrorlist.
- It allows for easy restoration of the original mirrorlist in case of corruption or malformed entries.
- It offers a safeguard against potential inclusion of untrustworthy or malicious sources.

#### Basic Usage

1. **Update Mirror List**: To fetch and rate the latest mirrors based on your location and save them to the mirrorlist file.

   ```bash
   sudo reflector --country 'United States' --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
   ```

   NOTE:

   Reflector specifies the age of the mirror servers in hours using the `--age` option. There isn't a builtin way to specify the age in seconds, minutes, days, or any other time unit. The age is defined as the time since the last synchronization of the mirror with the master server, and it's used to filter out potentially outdated mirrors.

   If you want to convert days to hours for the `--age` options, you'd have to do the conversion manually.

   ```bash
   reflector --age 168  # 7 days * 24 hours/day = 168 hours
   ```

2. **Refresh Database**: After updating the mirror list, refresh the package database.

   ```bash
   sudo pacman -Syyu
   ```

#### Advanced Usage

- **Custom Sorting**: You can sort mirrors by speed, age, score, etc.

  ```bash
  sudo reflector --sort rate --save /etc/pacman.d/mirrorlist
  ```

- **Multiple Countries**: You can specify multiple countries.

  ```bash
  sudo reflector --country 'United States,Canada' --sort rate --save /etc/pacman.d/mirrorlist
  ```

#### Configuration

- **Edit Default Settings**: To customize Reflector's default behavior, edit its configuration file.

  ```bash
  sudo vim /etc/xdg/reflector/reflector.conf
  ```

- **Available Options**: Within the configuration file, you can specify various options such as the mirror's country, protocol, and save location.

  ```vim
  # To set the country, use the --country flag.
  # Run "reflector --list-countries" to see available options.
  --country 'United States'
  ```

#### Automation

- **Systemd Timer**: Given your familiarity with systemd, you can set up a systemd timer to update the mirrorlist regularly.

  Create a systemd service and timer files, enable and start the timer.

#### Tips for Advanced Usage

- You can integrate Reflector into your post-install or maintenance scripts to ensure you always have the fastest mirrors.

### Automating Reflector with systemd

#### Create the Reflector Service File

1. Create a new systemd service file for Reflector:

   ```bash
   sudo vim /etc/systemd/system/reflector.service
   ```

2. Add the following content to the service file:

   ```ini
   [Unit]
   Description=Run Reflector

   [Service]
   Type=oneshot
   ExecStart=/usr/bin/reflector --country 'United States' --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
   ```

   Save and exit the editor.

#### Create the Reflector Timer File

1. Create a new systemd timer file for Reflector:

   ```bash
   sudo vim /etc/systemd/system/reflector.timer
   ```

2. Add the following content to the timer file:

   ```ini
   [Unit]
   Description=Run Reflector weekly

   [Timer]
   OnCalendar=weekly
   Persistent=true

   [Install]
   WantedBy=timers.target
   ```

   Save and exit the editor.

#### Enable and Start the Timer

1. Reload the systemd daemon to recognize your new service and timer:

   ```bash
   sudo systemctl daemon-reload
   ```

2. Enable the timer to start at boot:

   ```bash
   sudo systemctl enable reflector.timer
   ```

3. Start the timer:

   ```bash
   sudo systemctl start reflector.timer
   ```

4. To check the status of the timer:

   ```bash
   systemctl list-timers --all
   ```
