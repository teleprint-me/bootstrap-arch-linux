# Arch Linux Installation Guide

## UEFI Installation

### Pre-installation Steps

1. **Check Internet Connection**

   ```sh
   ping -c 3 google.com
   ```

2. **Update System Clock**

   ```sh
   timedatectl set-ntp true
   ```

3. **Partition Disk with gdisk**

   ```sh
   gdisk /dev/sdc
   gdisk /dev/nvme0n1
   ```

   Follow the on-screen instructions to create the partitions as per your
   schema.

4. **Format Partitions**

   ```sh
   mkfs.fat -F32 /dev/sdc1  # EFI
   mkfs.ext4 /dev/sdc2      # root
   mkswap /dev/sdc3         # swap
   mkfs.ext4 /dev/nvme0n1   # home
   ```

5. **Mount Partitions**

   ```sh
   # Mount the root partition
   mount /dev/sdc2 /mnt
   # Create the home and esp paths
   mkdir /mnt/home /mnt/boot
   # mount the esp partition
   mount /dev/sdc1 /mnt/boot
   # mount the home partition
   mount /dev/nvme0n1 /mnt/home
   # enable swap partition
   swapon /dev/sdc3
   ```

   NOTE:

   1. **EFI Partition as `/boot`**: In this setup, the EFI System Partition
      (ESP) is mounted directly at `/boot`. This is straightforward and often
      recommended because all the boot-related files (kernel, initramfs,
      bootloader) are in one place. When you install a new kernel, it
      automatically goes into the ESP.

   - Mounting Command: `mount /dev/sdc1 /mnt/boot`
   - Your `arch.conf` would then use paths like `/vmlinuz-linux-lts` and
     `/initramfs-linux-lts.img`.

   2. **EFI Partition as `/boot/efi`**: In this setup, the ESP is mounted at
      `/boot/efi`, and `/boot` remains on the root partition. This is a bit more
      complex because you have to ensure that the bootloader and kernel are in
      sync manually.

   - Mounting Command: `mount /dev/sdc1 /mnt/boot/efi`
   - Your `arch.conf` would then use paths like `/vmlinuz-linux-lts` and
     `/initramfs-linux-lts.img`, but you'd have to ensure these files are
     accessible at that path relative to the ESP.

   3. **EFI Partition as `/efi`**: This is the most complex setup because the
      ESP and `/boot` are now separated and require manual intervention. This
      requires copying the kernel and initramfs to `/efi` and then pointing
      `arch.conf` to them relative from its own path.

   Mounting the ESP directly at `/boot` might be the simpler and more
   straightforward option.

### Installation Steps

1. **Install Base Packages**

   ```sh
   pacstrap /mnt base linux-lts linux-lts-headers linux-firmware amd-ucode efibootmgr systemd man-db vim networkmanager
   ```

   NOTE:

   - This automatically executes `mkinitcpio` and builds the image from the
     preset, `/etc/mkinitcpio.d/linux-lts.preset: 'default'`. It then uses the
     default configuration file: `/etc/mkinitcpio.conf` and executes building
     the image using the given microcode.

   - Arch Linux does not install, setup, or configure any network management out
     of the box. It's crucial to setup and configure this once chrooted into the
     installation environment.

2. **Generate Fstab**

   ```sh
   genfstab -U /mnt >> /mnt/etc/fstab
   ```

3. **Chroot**

   ```sh
   arch-chroot /mnt
   ```

### Chrooted Steps

1. **Time Zone**

   ```sh
   ln -sf /usr/share/zoneinfo/Country/Zone /etc/localtime
   hwclock --systohc
   ```

2. **Localization**

   ```sh
   vim /etc/locale.gen
   ```

   Uncomment `en_US.UTF-8 UTF-8`, then generate the locale:

   ```sh
   locale-gen
   ```

3. **Network Configuration**

   ```sh
   echo 'localhost' > /etc/hostname
   ```

4. **Root Password**

   ```sh
   passwd  # NOTE: Disable root post-install!
   ```

5. **Install and Configure systemd-boot**

   ```sh
   bootctl --esp-path=/boot install
   ```

   This command installs `systemd-boot` into the EFI System Partition (ESP),
   which is mounted at `/boot` in this setup.

   Next, create a boot entry configuration file:

   ```sh
   vim /boot/loader/entries/arch.conf
   ```

   Add the following content to the file:

   ```plaintext
   title   Arch Linux
   linux   /vmlinuz-linux-lts
   initrd  /amd-ucode.img
   initrd  /initramfs-linux-lts.img
   options root="PARTUUID=your_root_partition_uuid" rw
   ```

   **Important Notes:**

   - **Paths**: Ensure that the paths to the kernel and initramfs images are
     relative to the ESP. In this setup, `/boot` is the ESP, so
     `/boot/vmlinuz-linux-lts` becomes `/vmlinuz-linux-lts` in the
     configuration.

   - **UUID**: Replace `your_root_partition_uuid` with the actual UUID of your
     root partition. You can find this by running `blkid`:

     ```sh
     blkid /dev/sdc2
     ```

     This will output the UUID, which you should then use to replace
     `your_root_partition_uuid`.

   - **Indentation**: `systemd-boot` does not accept tabs for indentation; use
     spaces instead.

   - **ESP Path**: The `--esp-path` flag is explicitly set to `/boot` to remove
     any ambiguity, even though it's the default location for the ESP in this
     setup.

6. **Configure systemd-boot Loader**

   The loader configuration is stored in the file located at
   `/boot/loader/loader.conf` in this setup. For more details on available
   options, you can refer to the `loader.conf(5)` documentation.

   ```sh
   vim /boot/loader/loader.conf
   # NOTE: Ensure the paths and options align with your specific setup.
   ```

   A sample loader configuration is provided below:

   ```plaintext
   # default arch.conf  # this is auto-discovered
   timeout 5
   console-mode keep
   editor no
   ```

   ### Notes:

   1. **Schema Differences**: The schema in this guide may differ from the
      official documentation to better suit your specific setup. For example,
      the `--esp-path` during the `bootctl` installation is set to `/boot`,
      which is the default location for the ESP in this setup.

   2. **Indentation**: `systemd-boot` does not accept tabs for indentation; use
      spaces instead.

   3. **Path**: The configuration file is located at `/boot/loader/loader.conf`
      in this setup, which may differ from other guides that place it under
      `/efi` or `/boot/efi`.

   4. **Options**: The options used here are tailored for this specific setup.
      For instance, `console-mode keep` is used to maintain the current console
      mode, and `editor no` is used to disable the boot menu editor for security
      reasons.

7. **Manually Add Initramfs**

   If `pacstrap` did not automatically generate the initramfs images, you'll
   need to manually execute the following command:

   ```sh
   mkinitcpio -P
   ```

   If `pacstrap` has already generated these images, you can skip this step.

   ### Notes:

   - `mkinitcpio -P` will generate initramfs images for all kernels installed on
     the system, based on the presets found in `/etc/mkinitcpio.d/`.

8. **Manually Add the EFI Boot Entry Using `efibootmgr`**

   If the `bootctl install` command failed to create an EFI boot entry, you can
   manually create one using `efibootmgr`:

   ```sh
   efibootmgr --create --disk /dev/sdX --part Y --loader "\\EFI\\systemd\\systemd-bootx64.efi" --label "Linux Boot Manager" --unicode
   ```

   Replace `/dev/sdX` and `Y` with the appropriate disk and partition numbers
   for your EFI system partition (ESP).

   **Note**: The path to the EFI binary must use backslashes (`\`) as
   separators.

   ```sh
   efibootmgr --create --disk /dev/sdc --part 1 --loader /boot/EFI/systemd/systemd-bootx64.efi --label "Arch Linux" --unicode
   ```

   ### Notes:

   - `--disk /dev/sdc`: Specifies the disk containing the EFI system partition
     (ESP).
   - `--part 1`: Specifies the partition number of the ESP.
   - `--loader /boot/EFI/systemd/systemd-bootx64.efi`: Specifies the path to the
     EFI application relative to the root of the ESP.
   - `--label "Arch Linux"`: Sets the boot manager display label.
   - `--unicode`: Optional, for specifying additional kernel parameters.

9. **Enable Network Manager**:

   After completing the initial setup, it's essential to enable `NetworkManager`
   to ensure Ethernet support upon reboot.

   ```sh
   systemctl enable NetworkManager.service
   ```

   This command will enable NetworkManager to start automatically during the
   boot process.

   **NOTE**:

   - This step is crucial if no alternative networking solution has been
     configured. Without enabling NetworkManager or an equivalent service, you
     won't have network connectivity upon boot, making it difficult to install
     additional packages or perform updates.

10. **Reboot**

    Once all the previous steps are successfully completed, it's time to exit
    the chroot environment and unmount all mounted partitions. Optionally, you
    can also disable the swap before rebooting.

    ```sh
    exit              # Exit the chroot environment
    umount -R /mnt    # Recursively unmount all mounted partitions under /mnt
    swapoff /dev/sdc3 # Disable the swap partition
    reboot            # Reboot the system
    ```

    ### Notes:

    - `exit`: Exits the chroot environment and returns you to the live system.
    - `umount -R /mnt`: Recursively unmounts all partitions mounted under
      `/mnt`.
    - `swapoff /dev/sdc3`: Disables the swap partition. This is optional but
      recommended.
    - `reboot`: Reboots the system, allowing you to boot into your newly
      installed Arch Linux.

### Post-Installation Steps

1. **Set Fallback Loader Entry**

   Create a fallback loader entry in case the primary one fails. This can be
   especially useful for system recovery.

   ```sh
   # Create a new loader entry configuration file for the fallback initramfs
   vim /boot/loader/entries/arch-fallback.conf
   ```

   Add the following content:

   ```
   title   Arch Linux Fallback
   linux   /vmlinuz-linux-lts
   initrd  /amd-ucode.img
   initrd  /initramfs-linux-lts-fallback.img
   options root="PARTUUID=your_root_partition_uuid" rw
   ```

   Replace `your_root_partition_uuid` with the UUID of your root partition,
   which you can find by running `blkid`.

   **NOTE**:

   - The only difference between this entry and the primary one is the `initrd`
     line, which points to the fallback initramfs.

2. **Create a User and Setup Sudo**

   After booting into your new Arch Linux system, it's advisable to create a
   non-root user for daily tasks and to configure sudo for administrative
   actions.

   **Create a New User**

   ```sh
   useradd -m -G wheel -s /bin/bash <username>
   ```

   - `-m`: Create the user's home directory.
   - `-G wheel`: Add the user to the `wheel` group, which is commonly used for
     administrative tasks.
   - `-s /bin/bash`: Set the default shell to Bash.
   - `username`: Replace with your desired username.

   **Set a Password for the New User**

   ```sh
   passwd <username>
   ```

   Follow the prompts to set a password for the new user.

   **Install and Configure Sudo**

   ```sh
   pacman -S sudo
   ```

   After installing sudo, you'll need to give members of the `wheel` group
   permission to use it.

   ```sh
   EDITOR=vim visudo
   ```

   Uncomment the following line to allow members of the `wheel` group to execute
   any command:

   ```
   %wheel ALL=(ALL:ALL) ALL
   ```

   Save and exit the editor.

3. **Disable the Root Account Safely**

   Before disabling the root account, it's crucial to ensure that your non-root
   user can perform administrative tasks using `sudo`. This is a safeguard to
   prevent accidentally locking yourself out of the system.

   1. **Log out of the root account**:

      ```sh
      logout
      ```

   2. **Log in as your non-root user**.

      ```sh
      <hostname> login: <username>
      Password:
      ```

   3. **Test sudo capabilities**:

      Try updating the system or any other administrative task to confirm that
      `sudo` is working as expected.

      ```sh
      sudo pacman -Syu
      ```

      If this works without issues, you can proceed to disable the root account.

   4. **Disable the root account**:

      ```sh
      sudo passwd -l root
      ```

      - `-l`: This option disables the password by changing it to a value which
        matches no possible encrypted value.

   **Note**:

   - Disabling the root account means you won't be able to log in as root or use
     `su` to become root. You'll need to use `sudo` for administrative tasks.
   - If you ever need to re-enable the root account, you can do so by booting
     into single-user mode or by using `sudo passwd root` to set a new root
     password.

4. **Disable the root account securely**:

   ```sh
   sudo usermod --expiredate 1 root
   ```

   This sets the expiration date for the root account to a date in the past,
   effectively disabling the account.

   **Note**:

   - This method is more secure than simply locking the password because it
     disables the account itself, not just the password.
   - If you ever need to re-enable the root account, you can do so by setting an
     expiration date in the future or removing the expiration date altogether
     with `sudo usermod --expiredate '' root`.

5. **Enable Multilib Support**

   Arch Linux is a 64-bit system, and by default, it doesn't support 32-bit
   applications. However, you can enable multilib support to install and run
   32-bit applications alongside 64-bit ones.

   1. **Edit the Pacman Configuration File**:

      Open `/etc/pacman.conf` with a text editor. You can use `vim`, `nano`, or
      any other text editor you're comfortable with.

      ```sh
      sudo vim /etc/pacman.conf
      ```

   2. **Uncomment Multilib Lines**:

      Find the `[multilib]` section and uncomment the lines for the repository,
      like so:

      ```plaintext
      [multilib]
      Include = /etc/pacman.d/mirrorlist
      ```

   3. **Update Package Database**:

      After saving the changes, update your package database to include the
      `multilib` repository.

      ```sh
      sudo pacman -Sy
      ```

   4. **Install 32-bit Libraries**:

      Now you can install 32-bit libraries and packages as needed.

      ```sh
      sudo pacman -S lib32-glibc lib32-gcc-libs lib32-zlib
      ```

   **Note**:

   - Enabling multilib support allows you to install and run 32-bit
     applications, which can be useful for compatibility with older software or
     specific use-cases.
   - Be cautious when installing 32-bit packages, as they can sometimes conflict
     with existing 64-bit packages.
