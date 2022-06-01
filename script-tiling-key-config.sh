#!/usr/bin/env bash

## This script configures the Pop Shell in conjunction with
## the GNOME keybindings and Workspace Bar extension.

### Sets up to 9 workspace shortcuts but maximum number is 4.

gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
gsettings set org.gnome.desktop.wm.preferences workspace-names \
    "['Main', 'School', 'Work', 'Music']"

# Set workspace shortcuts:
## Switch to workspace = "Super + NUM"
## Move to workspace = "Shift + Super + NUM"

for NUM in {1..9}
do
   gsettings set org.gnome.shell.keybindings switch-to-application-$NUM "[]"
   gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$NUM "['<Super>$NUM']"
   gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$NUM "['<Super><Shift>$NUM']"
done

echo "Workspace keybindings set!"
