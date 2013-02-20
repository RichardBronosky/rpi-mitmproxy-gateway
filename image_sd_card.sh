#!/usr/bin/env bash
# Todo: Make script detect the latest version of raspbian.

## No bash script should be considered releasable until it has this! ##
# Exit on use of an uninitialized variable
set -o nounset
# Exit if any statement returns a non-true return value (non-zero).
set -o errexit

VERSION=2013-02-09-wheezy-raspbian
CACHE_DIR=~/.raspbian
if [[ ! -f $CACHE_DIR/$VERSION.zip ]]; then
  (
    mkdir -f $CACHE_DIR
    cd $CACHE_DIR
    curl -O http://downloads.raspberrypi.org/images/raspbian/2013-02-09-wheezy-raspbian/2013-02-09-wheezy-raspbian.zip
  )
fi

if [[ $(uname) == Darwin ]]; then
  for d in $(diskutil list | grep dev); do diskutil info $d | grep -E 'Node|Media Name'; echo; done
else
  sudo parted -l | grep -A1 'Model:'
fi
read -p 'which disk? ' DISK

# make sure the unzipped image file gets deleted
trap 'rm $CACHE_DIR/$VERSION.img' EXIT
unzip $CACHE_DIR/$VERSION.zip -d $CACHE_DIR/
sudo umount $DISK* || true
time sudo dd bs=1m if=$CACHE_DIR/$VERSION.img of=$DISK
sleep 4; sudo umount $DISK* || true
