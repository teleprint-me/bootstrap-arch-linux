### Issue: Inconsistent Theming in GNOME 44.5

#### Issue Description:

- **Inconsistency**: Theming is inconsistent across applications, notably
  Nautilus (Files) and Settings.
- **Official Themes**: Adwaita Light works, but Dark does not.
- **Persistence**: Issue remains despite using GNOME Tweaks and `gsettings`.

#### `gsettings` Limitations:

1. **Color Scheme Commands**:

   ```sh
   # Sets light Adwaita theme
   gsettings set org.gnome.desktop.interface color-scheme default

   # Sets dark Adwaita theme
   gsettings set org.gnome.desktop.interface color-scheme prefer-dark
   ```

   - **Note**: Partial application; Nautilus and Settings may still use Light
     theme.

2. **GTK Theme Commands**:

   ```sh
   # Resets GTK theme
   gsettings reset org.gnome.desktop.interface gtk-theme

   # Sets dark Adwaita theme
   gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
   ```

   - **Note**: Partial application; some applications may still use Light theme.

#### Possible Causes:

1. Transitional issues due to upcoming major release (45).
2. Deprecated and renamed GNOME applications.
3. Conflict with `libadwaita` and its `AdwStyleManager:color-scheme`.

#### Workarounds:

1. **System-Wide Environment Variable**:

   ```sh
   # Sets Arc:dark theme system-wide
   echo 'GTK_THEME="Arc:dark"' | sudo tee -a /etc/environment
   ```

   - Reboot to apply changes.

2. **Session-Wide Environment Variable**: Add `GTK_THEME=Arc:dark` to `.bashrc`
   or `.zshrc`.
3. **Custom Desktop Entry**: Modify `.desktop` files to set `GTK_THEME`.
4. **Downgrade Packages**: Risky and not recommended.
5. **Switch Desktop Environment**: KDE, XFCE, or Cinnamon as alternatives.
6. **Use Different File Manager**: Consider Thunar or Dolphin.
7. **Community Themes**: Check [GNOME-Look](https://www.gnome-look.org/).
8. **Scripted Theme Toggle**: Create a script to toggle themes.

#### Additional Notes:

- [Community Discussion](https://bbs.archlinux.org/viewtopic.php?id=275441)
  labels the issue as "partially solved."
- Shell themes should be updated per GNOME-shell release; report issues to theme
  developers.
- The issue may relate more to core packages or Adwaita configuration.
