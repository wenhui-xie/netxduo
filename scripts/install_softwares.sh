#! /bin/bash

sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y gcc-multilib g++-multilib ninja-build gcovr libpcap-dev:i386 ethtool isc-dhcp-server libcmocka-dev:i386 gcc-arm-none-eabi unifdef dos2unix python3-pip
