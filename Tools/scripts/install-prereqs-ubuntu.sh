#!/bin/bash
set -e

CWD=$(pwd)
OPT="/opt"

BASE_PKGS="gawk make git arduino-core curl"
SITL_PKGS="g++ python-pip python-matplotlib python-serial python-wxgtk2.8 python-scipy python-opencv python-numpy python-pyparsing ccache"
PYTHON_PKGS="pymavlink MAVProxy droneapi"
PX4_PKGS="python-serial python-argparse openocd flex bison libncurses5-dev \
          autoconf texinfo build-essential libftdi-dev libtool zlib1g-dev \
          zip genromfs"
UBUNTU64_PKGS="libc6:i386 libgcc1:i386 gcc-4.6-base:i386 libstdc++5:i386 libstdc++6:i386"
ASSUME_YES=false

# Ardupilot Tools
ARDUPILOT_TOOLS="ardupilot/Tools/autotest"

function maybe_prompt_user() {
    if $ASSUME_YES; then
        return 0
    else
        read -p "$1"
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            return 0
        else
            return 1
        fi
    fi
}


OPTIND=1  # Reset in case getopts has been used previously in the shell.
while getopts "y" opt; do
    case "$opt" in
        \?)
            exit 1
            ;;
        y)  ASSUME_YES=true
            ;;
    esac
done

if $ASSUME_YES; then
    APT_GET="sudo apt-get -qq --assume-yes"
    APT_ADD_REPO="sudo add-apt-repository -y"
else
    APT_GET="sudo apt-get"
    APT_ADD_REPO="sudo add-apt-repository"
fi

sudo usermod -a -G dialout $USER

$APT_GET remove modemmanager
$APT_GET update
$APT_GET install $BASE_PKGS $SITL_PKGS $PX4_PKGS $UBUNTU64_PKGS
sudo pip -q install $PYTHON_PKGS


if [ ! -d PX4Firmware ]; then
    git clone https://github.com/diydrones/PX4Firmware.git
fi

if [ ! -d PX4NuttX ]; then
    git clone https://github.com/diydrones/PX4NuttX.git
fi

if [ ! -d VRNuttX ]; then
    git clone https://github.com/virtualrobotix/vrbrain_nuttx.git VRNuttX
fi


# https://launchpad.net/~terry.guo/+archive/ubuntu/gcc-arm-embedded
$APT_GET install python-software-properties
$APT_ADD_REPO ppa:terry.guo/gcc-arm-embedded
$APT_GET update
$APT_GET install gcc-arm-none-eabi
