#!/usr/bin/env bash
# This script looks for the following environment variables and prompts if they are not present:
# PUBKEY
# INSTALL_USER

[[ -z $INSTALL_USER ]] && export INSTALL_USER=$SUDO_USER
export HOME=$(bash <<< "echo ~$INSTALL_USER")

## No bash script should be considered releasable until it has this! ##
# Exit on use of an uninitialized variable
set -o nounset
# Exit if any statement returns a non-true return value (non-zero).
set -o errexit

# Remove cruft packages
apt-get -y remove --purge xserver-common
apt-get -y remove --purge x11-common
apt-get -y remove --purge gnome-icon-theme
apt-get -y remove --purge gnome-themes-standard
apt-get -y remove --purge penguinspuzzle
apt-get -y remove --purge desktop-base
apt-get -y remove --purge desktop-file-utils
apt-get -y remove --purge hicolor-icon-theme
apt-get -y remove --purge raspberrypi-artwork
apt-get -y remove --purge omxplayer
rm -rf /home/pi/python_games
apt-get -y autoremove

# Add useful packages
apt-get -y update
# version control
apt-get -y install git
# text editor
apt-get -y install vim
# terminal multiplexer
apt-get -y install tmux
# zeroconf/bonjour
apt-get -y install libnss-mdns
# python essentials
apt-get -y install python-dev python-pip

# Update firmware
wget http://goo.gl/1BOfJ -O /usr/bin/rpi-update && chmod +x /usr/bin/rpi-update
rpi-update

# Update MotD
cat << EOF > /etc/motd
$(tput setaf 2)
   .~~.   .~~.
  '. \ ' ' / .'$(tput setaf 1)
   .~ .~~~..~.
  : .~.'~'.~. :
 ~ (   ) (   ) ~
( : '~'.~.'~' : )
 ~ .~ (   ) ~. ~
  (  : '~' :  ) $(tput sgr0)Raspbian-mod$(tput setaf 1)
   '~ .~~~. ~'
       '~'
$(tput sgr0)
EOF

# Setup shell
cp /etc/skel/.bashrc ~/.bashrc
echo "alias ll='ls -l'" >> ~/.bash_aliases
chown -R $(id -un $INSTALL_USER):$(id -gn $INSTALL_USER) ~/.bashrc ~/.bash_aliases
[[ -z $PUBKEY ]] && read -p 'ssh pubkey (conent or URL to pubkey): ' PUBKEY
if [[ -n $PUBKEY ]]; then
  (umask 077; mkdir -p ~/.ssh; touch ~/.ssh/authorized_keys)
  echo >> ~/.ssh/authorized_keys
  if [[ $PUBKEY =~ ^https?:// ]]; then
    curl -sL $PUBKEY >> ~/.ssh/authorized_keys
  else
    echo $PUBKEY >> ~/.ssh/authorized_keys
  fi
  chown -R $(id -un $INSTALL_USER):$(id -gn $INSTALL_USER) ~/.ssh
fi

# Setup vim
echo "export EDITOR=vim" >> ~/.bashrc
cat << EOF >> ~/.vimrc
syntax enable 
set hidden
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
EOF

# Install mitmproxy (from github until transparent proxying makes its way into the stable release)
# mitmproxy requirements
apt-get -y install python-imaging python-imaging-dbg python-lxml python-lxml-dbg python-pyasn1 python-urwid python-openssl python-openssl-dbg
cd /usr/local/src
git clone https://github.com/cortesi/netlib
git clone https://github.com/cortesi/mitmproxy
( cd netlib && python setup.py install)
( cd mitmproxy && python setup.py install)

# Install driver router AP software
git clone https://github.com/RichardBronosky/RTL8188-hostapd
RTL8188-hostapd/scripts/setup.sh

# Flush cache? Zero out drive?
# Make sure the file gets deleted even if there is an error or someone presses ctrl-c
trap 'rm zero.file' EXIT
dd if=/dev/zero of=zero.file bs=1024 || true
sync; sleep 60; sync
