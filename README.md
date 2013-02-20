<img src="http://www.raspberrypi.org/wp-content/uploads/2012/03/Raspi_Colour_R.png" width="90" />

# Notice

At this point this project is basically just a placeholder for me and my cohort to collaborate on.

# Overview

RPi-mitmproxy-gateway is an open platform project for turning a RaspberryPi and a USB WiFi dongle into an access point for mobile app debugging. It uses the [mitmproxy project](https://github.com/cortesi/mitmproxy) to put a transparent proxy between your mobile device and the internet. It has a commandline interface for inspecting and editing HTTP & HTTPS traffic.

RPi-mitmproxy-gateway is a modification to the standard Raspbian image. It fits easily on a 2 GB SD card with ~550 MB of free space remaining. For those looking for additional space, larger cards are supported as well.

Bonjour support means that you can SSH into your Pi without having to know it's IP address. Simply:

    ssh pi@raspberrypi.local
    
# Features

* Removes X11 and desktop packages
* Adds packages all hackers need
  * Git
  * Bonjour
  * Full Vim (with a basic .vimrc to get you ready for hacking)
* [updates firmware with Hexxeh](https://github.com/Hexxeh/rpi-update)

# Building

You can build your own RPi-mitmproxy-gateway by starting with the official image from the Raspberry Pi Foundation. Check [the foundation's download page](http://www.raspberrypi.org/downloads) for the download link and instruction for creating a bootable SD card.

Once you've created your Raspbian SD card, boot your Raspberry Pi and execute this command from the command prompt:

    sudo bash < <( curl -L https://github.com/RichardBronosky/rpi-mitmproxy-gateway/raw/master/initialize.sh )

If you are debugging, I suggest adding an -x to bash, like so:

    sudo bash -x < <( curl -L https://github.com/RichardBronosky/rpi-mitmproxy-gateway/raw/master/initialize.sh )
    
This command will take several minutes to complete, and should leave you with a freshly optimized Raspbian installation.

# ToDo

So far I've only cloned the raspbian-mod project.
I've yet to put the meat of the project in here.

