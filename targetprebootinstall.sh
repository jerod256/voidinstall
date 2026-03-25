################################################
### Secure Void Linux Installation 	     ###
### preboot install on a preprepared disk    ###
### by: Liz Boudreau		   	     ###
### License: GPL-2.0		   	     ###
################################################

### This script is a fully automated installation of void linux from the command line
### it is meant to run from a live installation image of void linux
### the script is a work in progress, use at your own risk. It is not supported. Issues will be ignored.
### Sources used for creating this script: man-pages, void linux manual, https://github.com/dylanbegin/void-install.git

### The target system will have the following installation features and qualities
### a single volume inside a LUKS2 partition, ZRAM and swapfile will be used for swap
### An EFI partition containining the kernel and initramfs images
### an existing limine bootloader on an existing, unencrypted boot partition

### EFI Stub, secure boot and TPM2 unlock would be nice, but to simplify the installation process. that will be left to post-installation to simplify this installation script

### Note that this script will accept a preprepared disk partition. the first version of this will assume a simple partition, ext4 filesystem, directly on a physical disk. then the script will install a system on that.
### future upgrades will include accepting a LUKS2 encrypted partition, although much work will have to be done to adjust the kernel, initramfs generation and bootloader entry, so the first version of this script will be on an unencrypted partition.
