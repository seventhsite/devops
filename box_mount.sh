#!/bin/bash

set -e

# Set mount point and options. CHANGE THE "uXXXXX" to your username. Other is optional
HETZNER_USER="uXXXXX"
MOUNT_POINT="$HOME/box"
PRIVATE_KEY="$HOME/.ssh/id_rsa"
OPTIONS="default_permissions,identityfile=$PRIVATE_KEY,noauto,_netdev,reconnect,uid=$(id -u),gid=$(id -g)"

HETZNER_URL="$HETZNER_USER@$HETZNER_USER.your-storagebox.de"
HETZNER_REMOTE_DIR="/"

# Check if mount directory exists and create it if not
if [ ! -d "$MOUNT_POINT" ]; then
  read -p "Directory $MOUNT_POINT does not exist. Do you want to create it? (y/n) " dir
  if [ "$dir" != "y" ]; then
    echo "Please provide correct path to mount directory in \$MOUNT_POINT variable. Script aborted."
    exit 1
  else
    mkdir "$MOUNT_POINT"
    echo "Directory $MOUNT_POINT created"
  fi
fi

if [ "$EUID" -eq 0 ]; then
  read -p "It would be better not to run this script as root. Continue anyway? (y/n) " run_as_root
  if [ "$run_as_root" != "y" ]; then
    echo "Script aborted."
    exit 1
  fi
fi

# Check if mount point is already mounted and unmount if necessary
if mount | grep -q "$MOUNT_POINT"; then
  read -p "Box directory is already mounted. Do you want to unmount it? (y/n) " unmount
  if [ "$unmount" == "y" ]; then
    fusermount -u "$MOUNT_POINT"
    echo "Box directory has been unmounted."
    exit 0
  else
    echo "Nothing to do. Bye!"
    exit 0
  fi
fi

# Check if sshfs package is installed and install it if not
if ! dpkg -s sshfs >/dev/null 2>&1; then
  read -p "sshfs package is not installed. Do you want to install it? (y/n) " install
  if [ "$install" == "y" ]; then
    echo "Installing..."
    sudo apt-get update
    sudo apt-get install -y sshfs
  else
    echo "You need to install sshfs package. Try to use \"sudo apt install sshfs\""
  fi
fi

# Check if private key exists
if [ -e "$PRIVATE_KEY" ]; then
  echo "Trying to access with $PRIVATE_KEY private key..."
else
  read -p "Can't find $PRIVATE_KEY private key. Do you want to create it? (y/n) " create_key
  if [ "$create_key" == "y" ]; then
    ssh-keygen -f $PRIVATE_KEY
    echo "Installing your key. Please enter your Hetzner box password for user $HETZNER_USER"
    cat $PRIVATE_KEY.pub | ssh HETZNER_URL install-ssh-key
  else
    echo "Continuing without private key. Please enter password for authentication."
  fi
fi

# Mount remote directory to local mount point
sshfs -o "$OPTIONS" "$HETZNER_URL":"$HETZNER_REMOTE_DIR" "$MOUNT_POINT"
echo ""
echo "Box directory has been mounted!"
df -h $MOUNT_POINT
echo ""
#echo "Here is its content:"
#cd $MOUNT_POINT
#ls -la
