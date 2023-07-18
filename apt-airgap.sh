#!/bin/bash

# Specify the Ubuntu distro and the USB stick path
UBUNTU_DISTRO="lunar"  # For example: focal, bionic, etc.
USB_PATH="/mnt/external"  # Path where USB is mounted

# The location of the repository to mirror
REPO="http://archive.ubuntu.com/ubuntu"

# Use debmirror to download the repository
debmirror --no-check-gpg \
          --host=archive.ubuntu.com \
          --root=ubuntu \
          --method=http \
          --progress \
          --dist="${UBUNTU_DISTRO},${UBUNTU_DISTRO}-updates,${UBUNTU_DISTRO}-backports,${UBUNTU_DISTRO}-security" \
          --section=main,restricted,universe,multiverse \
          --arch=amd64 \
          --nosource \
          "${USB_PATH}/ubuntu/"

chmod -R 744 "${USB_PATH}"

# Create the USAGE.md file with the sources.list instructions
echo "To use this local mirror of the Ubuntu repository:

1. Mount the USB stick on your Ubuntu system. You can use the mount command:
   'sudo mount /dev/sdx /mnt' (replace /dev/sdx with your USB device).

2. Backup your current sources.list file:
   'sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak'

3. Modify the /etc/apt/sources.list file:
   'sudo nano /etc/apt/sources.list'

   Comment out the existing lines (put a '#' at the start of the line) to keep them for later.
   Add the following line to the file:

   deb file:/mnt/ubuntu/ ${UBUNTU_DISTRO} main restricted universe multiverse
   deb file:/mnt/ubuntu/ ${UBUNTU_DISTRO}-updates main restricted universe multiverse
   deb file:/mnt/ubuntu/ ${UBUNTU_DISTRO}-backports main restricted universe multiverse

4. Update APT:
   'sudo apt-get update'

Now APT will use the local mirror on the USB stick when installing packages." > "${USB_PATH}/USAGE.md"

echo "Mirroring completed and instructions written to USAGE.md"
