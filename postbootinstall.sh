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

### This script will setup:
### 1. verify service startup
### 1.25. verify internet connection and connection to repos
### 1.5. a system update from through the package manager from the repos
### 2. upgrade the kernel and make a bootloader entry for the new kernel
### 3. tweak kernel parameters to optimize for a desktop workspace
### 3.25. setup zswap (not zram)
### 3.5. install the interactive fish shell for the user
### 3.75. start cronie job for trimming drive
### 4. install a graphical environment
### 5. install dotfiles for graphical environment
### 6. make sure graphical environment starts up xdg_desktop_portal_wlroots and polkitagent

### Another reboot will be required to make use of the kernel upgrade

pkg_gui="xdg_desktop_portal_wlroots polkit fuzzel wl-clipboard swaybg waybar swaylock swayidle grim slurp wiremix bluetui nwg-look nwg-drawer kitty foot ffmpeg firefox qutebrowser firejail mesa fastfetch"

