### Timeshift Quickstart Guide for Arch Linux

#### Installation

```bash
sudo pacman -S timeshift
```

#### Initial Setup

1. **Launch**: Open a terminal and run `sudo timeshift-launcher`.

2. **Snapshot Type**: Choose between RSYNC (general-purpose) and BTRFS (requires
   BTRFS filesystem).

3. **Storage Location**: Select a directory with sufficient free space.

4. **Frequency**: Set how often you want snapshots (daily, weekly, etc.).

#### Taking Snapshots

- **Manual**: Run `sudo timeshift --create --comments "Snapshot before XYZ"`.

- **Automatic**: If scheduled, Timeshift will handle this for you.

#### Restoring Snapshots

1. List available snapshots: `sudo timeshift --list`.

2. Restore a snapshot: `sudo timeshift --restore`.

#### Additional Commands

- Exclude specific folders: Add them in the "Settings" tab in the GUI or use
  `--exclude` in CLI.
- Enable boot snapshots: Useful for system state tracking.

#### Tips for Advanced Usage

- Given your scripting skills, consider automating snapshot tasks via cron jobs
  or systemd timers.

- Integrate Timeshift CLI commands into your existing system maintenance
  scripts.
