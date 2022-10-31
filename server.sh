#!/bin/bash

MY_TIMEZONE="America/Toronto"
MY_USER="alex"
MEDIA_USER="media-manager"
PUBLIC_KEYS_SOURCE="https://github.com/mrozbarry.keys"

# EST
echo "Setting timezone to $MY_TIMEZONE"
ln -sf "/usr/share/zoneinfo/$MY_TIMEZONE" /etc/localtime

hwclock --systohc

pacman -Sy archlinux-keyring
pacman -S git base-devel neovim syslinux sudo zsh openssh lightdm plasma-meta

nvim /etc/locale.gen +"echo 'Uncomment en_US.UTF-8'"
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

syslinux-install_update -i -m

echo "Creating user '$MY_USER'"
useradd -m -G wheel ssh -s /bin/zsh "$MY_USER"
passwd "$MY_USER"

mkdir -p "/home/$MY_USER/.ssh"
curl "$PUBLIC_KEYS_SOURCE" >> "home/$MY_USER/.ssh/authorized_keys"
chown -R "$MY_USER":"$MY_USER" "/home/$MY_USER/.ssh"
chmod 700 "/home/$MY_USER/.ssh"
chmod 600 "/home/$MY_USER/.ssh/authorized_keys"

echo "Creating user '$MEDIA_USER'"
useradd -m "$MEDIA_USER

cd "/home/$MY_USER"
sudo -u alex git clone https://aur.archlinux.org/plasma-bigscreen-git.git
cd "/home/$MY_USER/plasma-bigscreen-git"
sudo -u alex makepkg -i -s

systemctl enable lightdm
systemctl enable ssh
