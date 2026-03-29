#!/bin/bash
######################################
### Secure Void Linux Installation ###
### by: Liz Boudreau		   ###
### License: GPL-2.0		   ###
######################################

### This script will do a fully automated installation of void linux from the command line
### this script is meant to be run after the first boot
### this script was designed and tested with the void linux image released in 2025 and assumes Linux 6.12

### This script is a work in progress, use at your own risk. It is not supported. Issues will be ignored.
### Sources used for creating this script: man-pages, void linux manual, and https://github.com/dylanbegin/void-install.git

### The target system will have the following installation features and qualities
### a single volume inside a LUKS2 partition, ZRAM and swapfile will be used for swap
### An EFI partition containining the kernel and initramfs images
### limine bootloader

##### Instructions for Running this script
### 1. Should be performed booting up into the target system - do no run in live session
### 2. run $ git clone https://github.com/jerod256/voidinstall.git
### 3. cd voidinstall
### 4. chmod +x postbootinstall.sh
### 5. make sure you read the postbootinstall.sh script, because the next part requires root access
### 6. sudo ./postbootinstall.sh

### THIS SCRIPT ASSUMES THE TARGET SYSTEM IS CONNECTED TO THE INTERNET VIA ETHERNET

### This script will setup:
### 1. setup services installed in preboot install
### 2. activate services
### 3. updates system via package manager
### 4. installs fonts
### 5. installs a graphical desktop environment (sway)
### 6. sets timezone (Canada/Eastern)

### package list for gui
pkg_gui_wl="xdg-desktop-portal-wlr wmenu wl-clipboard sway swaybg Waybar swaylock swayidle grim slurp wiremix bluetui kitty foot ffmpeg firefox qutebrowser firejail mesa fastfetch pam_rundir yazi mako neovim fish"
### package list for fonts
pkg_fonts="dejavu-fonts-ttf xorg-fonts noto-fonts-ttf noto-fonts-cjk noto-fonts-emoji nerd-fonts"
### remove mesa and install nouveau for an nvidia GPU. this script will not deal with proprietary nvidia drivers
### add session for setting up pam_rundir and adding line:
### '-session optional pam_rundir.so' /etc/pam.d/system-login


################################################
##### Setup Services, Daemons and Security #####
################################################
#
ln -s /etc/sv/acpid /var/service/ #for laptop only
ln -s /etc/sv/bluetoothd /var/service/ #do not include for gaming distro
ln -s /etc/sv/dbus /var/service/
ln -s /etc/sv/ufw /var/service/
ln -s /etc/sv/tlp /var/service/ #for laptop only
ln -s /etc/sv/tlp-pd /var/service/ #for laptop only
ln -s /etc/sv/crond /var/service/
ln -s /etc/sv/connmand /var/service/ #for laptop, replace with dhcpcd for desktop
ln -s /etc/sv/seatd /var/service/
ln -s /etc/sv/greetd /var/service/ #consider not using for gaming
ln -s /etc/sv/socklog-unix /var/service/
ln -s /etc/sv/nanoklogd /var/service/
ln -s /etc/sv/ntpd /var/service/
ln -s /etc/sv/polkitd /var/service/

### disable dhcpcd, iptables and nftables if enabled
sv down dhcpcd
sv down iptables
sv down nftables
rm /var/service/dhcpcd #do not remove if desktop, instead enable
rm /var/service/iptables
rm /var/service/nftables

sv up acpid
sv up bluetoothd
sv up dbus
sv up ufw
sv up tlp
sv up tlp-pd
sv up crond
sv up connmand
sv up seatd
sv up socklog-unix
sv up nanoklogd
sv up ntpd
sv up polkitd

### perform a system update. note if this fails its probably because the internet is not there
xbps-install -Su


### install fonts and link
xbps-install -S $pkg_fonts
ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps-except-emoji.conf /etc/fonts/conf.d

### Install graphical system and apps
xbps-install -S $pkg_gui_wl

### setting time zone
ln -sf /usr/share/zoneinfo/Canada/Eastern /etc/localtime

### setting up pam to setup the runtime dir for sway to work
sed -i '$a -session optional pam_rundir.so' /etc/pam.d/system-login

### setup a cron job to trim the SSDs
touch /etc/cron.weekly/fstrim
cat <<EOF > /etc/cron.weekly/fstrim
#!/bin/sh
/sbin/fstrim -a -v
EOF
chmod u+x /etc/cron.weekly/fstrim

### setting up fish as the default shell
command -v fish | sudo tee -a /etc/shells
chsh -s "$(command -v fish)"

### To do: priority list, not comprehensive
### 1. do zswap setup in script
### 2. look at adjusting kernel parameters
### 	a. vm.vfs_cache_pressure
### 	b. vm.swappiness
### 	c. vm.dirty_ratio
### 	d. max_pool_percent
### 	e. zpool
### 	f. transparent_hugepage

### Do later because of the complexity and/or risks:
### 1. Kernel update
### 2. dotfile update

##### Check after running this script:
### 1. services linked and running (use '# sv status /var/service/*' and 'ls /var/service/')
### 2. check time
### 3. check /etc/pam.d/system-login
### 4. check the cron job for fstrim
