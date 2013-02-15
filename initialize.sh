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

# Add useful packages
apt-get -y autoremove
apt-get -y update
apt-get -y install git
apt-get -y install libnss-mdns
apt-get -y install vim

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

# Setup vim
cp /etc/skel/.bashrc /home/pi/.bashrc
echo "export EDITOR=vim" >> /home/pi/.bashrc
cat << EOF > /home/pi/.vimrc
syntax enable 
set hidden
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
EOF

# Flush cache?
dd if=/dev/zero of=zero.file bs=1024
sync; sleep 60; sync
rm zero.file
