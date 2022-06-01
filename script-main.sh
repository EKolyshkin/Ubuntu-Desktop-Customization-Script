#!/usr/bin/env bash

## This script is meant to install everything I need for a comfortable daily driver experience on Ubuntu.

## Set ZSH as default shell
sudo apt install zsh -y
chsh -s $(which zsh)

## Set Custom Aliases
cp -r Configuration/ .shell_aliases .vim/ .vscode-oss/ .librewolf/ .vimrc .zshrc ~/ && echo "Shell aliases set..." || echo "Shell aliases not found!"
source ~/.zshrc
source ~/.shell_aliases 
source ~/.vimrc

## APT Repositories
sudo apt install apt-transport-https curl -qqy

sudo add-apt-repository ppa:unit193/encryption --yes > /dev/null		## Veracrypt
sudo add-apt-repository ppa:apandada1/foliate --yes > /dev/null			## Foliate
# sudo add-apt-repository ppa:obsproject/obs-studio --yes	> /dev/null		## OBS Studio
# sudo add-apt-repository ppa:phoerious/keepassxc --yes > /dev/null		## KeePassXC
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg >/dev/null && echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list > /dev/null										## VS Codium
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list				## Brave Browser
# sudo add-apt-repository ppa:appimagelauncher-team/stable			## AppImageLauncher


sudo apt update -qqy && sudo apt upgrade -qqy
echo "Repositories set..."


## APT Packages
cat apps-list | xargs sudo apt install -qqy 


# Proton Bridge, Pop Shell, Extension Installer
# wget -cq https://protonmail.com/download/bridge/protonmail-bridge_1.8.7-1_amd64.deb -O protonbridge.deb
git clone https://github.com/pop-os/shell && sudo apt install make node-typescript -qqy > /dev/null

# sudo dpkg -i protonbridge.deb > /dev/null && rm protonbridge.deb
make -C shell/ local-install > /dev/null && rm -rf shell/ 

wget -qO gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer" > /dev/null
chmod +x gnome-shell-extension-installer
sudo mv gnome-shell-extension-installer /usr/bin/

# AppImageLauncher
# wget -cq https://cdn.filen.io/sync/updates/filen-setup.AppImage
# ail-cli integrate ./filen-setup.AppImage

# curl -s https://api.github.com/repos/probonopd/Zoom.AppImage/releases \ # Zoom Desktop
#	| grep "browser_download_url.*AppImage" \
#	| cut -d : -f 2,3 \
#	| tr -d \" \
#	| wget -qi - -O Zoom.AppImage
# ail-cli integrate ./Zoom.AppImage

## Remove Preinstalled Apps
echo "Apps installed..."

sudo apt remove gedit gnome-shell-extension-ubuntu-dock gnome-shell-extension-desktop-icons* -shell-extension-desktop-icons-ng --purge -qq
sudo snap remove snap-store > /dev/null	# Removes Ubuntu Software
sudo apt install gnome-software gnome-software-plugin-snap # Installs good software center with snap functionality

## GNOME Extensions
gnome-shell-extension-installer 19 906 1401 3193 3843 1319 307 4085 4451 # User Themes, Sound Input Output Device Chooser, Bluetooth Quick Connect, Blur My Shell, Just Perfection, GSConnect, Dash to Dock, Big Sur Status Area, Tofu Menu

## Big Sur Status Area Date Format
### "%a %e %b %l:%M %p"


gnome-extensions enable -q pop-shell@system76.com
gnome-extensions enable -q bluetooth-quick-connect@bjarosze.gmail.com
gnome-extensions enable -q sound-output-device-chooser@kgshank.net
gnome-extensions enable -q ubuntu-appindicators@ubuntu.com
gnome-extensions enable -q blur-my-shell@aunetx

echo "Extensions installed..."


## Miscellaneous GNOME Settings
gsettings set org.gnome.desktop.interface enable-hot-corners false		# Disables Hot Corner
# gsettings set org.gnome.desktop.notifications show-in-lock-screen false		# Disables lock screen notifications
gsettings set org.gnome.desktop.interface clock-format '12h'			# Change clock to AM/PM
favorites=$(cat './favorites-config')
gsettings set org.gnome.shell favorite-apps "$favorites"			# Sets app favorites
# gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize:'	# Moves titlebar buttons left

## Set symlinks to Filen Sync folders for default directories
rmdir Music Documents Pictures
ln -s /home/user/Filen\ Sync/Documents/ Documents
ln -s /home/user/Filen\ Sync/Music Music
ln -s /home/user/Filen\ Sync/Photos/ Pictures

touch ~/Templates/New\ Document.txt						# Makes blank document template for file manager
nmcli radio wifi off && sudo macchanger -r wlp2s0 && nmcli radio wifi on        # Randomizes MAC address
cp ./bookmarks-config ~/.config/gtk-3.0/bookmarks
sudo update-alternatives --quiet --set editor /usr/bin/vim.basic		# Set VIM as default editor

# Set Fonts
gsettings set org.gnome.desktop.interface document-font-name 'FreeSans 11'
gsettings set org.gnome.desktop.interface font-name 'FreeSans 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'FreeSans Semi-Bold 11'

# Set Cursor Theme
gsettings set org.gnome.desktop.interface cursor-theme 'DMZ-Black'

echo "Miscellaneous preferences set..."


## Set Custom Keyboard Shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'Open Tor Browser'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Super>R'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'torbrowser-launcher'"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'Open Music'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Super>M'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'elisa'"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'Open Notes'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Super>N'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'./Applications/Joplin*'"

gsettings set org.gnome.desktop.wm.keybindings close ["'<Primary>q'"]
gsettings set org.gnome.desktop.wm.keybindings minimize ["'<Primary>,'"]
gsettings set org.gnome.desktop.wm.keybindings maximize ["'<Primary>m'"]

echo "Keyboard shortcuts set..."


## WhiteSur Icons
wget -cq https://github.com/vinceliuice/WhiteSur-icon-theme/archive/refs/heads/master.zip -O WhiteSur-icon-theme-master.zip
unzip -qq WhiteSur-icon-theme-master.zip
chmod u+x ./WhiteSur-icon-theme-master/install.sh
./WhiteSur-icon-theme-master/install.sh \
    --theme red /
    > /dev/null
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur-dark" && echo "Icon theme set..." || echo "Icon theme failed to install!"
rm -rf WhiteSur-icon-theme-master/ WhiteSur-icon-theme-master.zip 


## WhiteSur GDM (Lockscreen) Theme
wget -c https://github.com/vinceliuice/WhiteSur-gtk-theme/archive/refs/heads/master.zip -O WhiteSur-gtk-theme-master.zip > /dev/null
unzip -qq WhiteSur-gtk-theme-master.zip
chmod u+x ./WhiteSur-gtk-theme-master/tweaks.sh
sudo ./WhiteSur-gtk-theme-master/tweaks.sh \
    --gdm \
    --dash-to-dock \
    --opacity normal \
    --color Dark \
    --theme purple \
    --icon simple \
    --background /home/user/Pictures/Wallpapers/Desktop/macOS/macOS\ Monterey\ Wallpaper\ 2\ YTECHB.jpg \
    > /dev/null && echo "Lockscreen theme set..." || echo "Lockscreen theme failed to install!"


## WhiteSur Firefox & Snap Theme
# firefox &
# sleep 5 && killall -q firefox	# Initialize and quit Firefox before applying theme
# ./WhiteSur-gtk-theme-master/tweaks.sh -f monterey > /dev/null && echo "Firefox theme set..." || echo "Firefox theme failed to install!"
./WhiteSur-gtk-theme-master/tweaks.sh --snap > /dev/null && echo "Snap theme set..." || echo "Snap theme failed to install!"


## WhiteSur GTK & Shell Theme
chmod u+x ./WhiteSur-gtk-theme-master/install.sh
./install.sh \
    --round \
    --opacity normal \
    --color Dark \
    --darker \
    --theme red \
    --monterey \
    --libadwaita \
    --icon ubuntu \
    --background /home/user/Pictures/Wallpapers/Desktop/macOS/macOS\ Monterey\ Wallpaper\ 2\ YTECHB.jpg \
    > /dev/null
gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-dark' && echo "Application theme set..." || echo "Application theme failed to install!"
rm -rf WhiteSur-gtk-theme-master/ WhiteSur-gtk-theme-master.zip 


## Set Up Workspace Names and Settings
./script-tiling-key-config.sh

## For Apple keyboards and Keychron
sudo touch /etc/modprobe.d/hid_apple.conf
sudo tee /etc/modprobe.d/hid_apple.conf <<< "options hid_apple fnmode=2 swap_opt_cmd=1" > /dev/null
sudo update-initramfs -u > /dev/null && echo "Apple keyboard configuration set..." || echo "Apple keyboard configuration failed!"


## Reboot to Solidify Changes
read -p "All done! Reboot to solidify changes (y/N)? " ans
if [ "$ans" = "y" ]; then
	reboot
else
	exit
fi
