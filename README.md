# devops
DevOPS scripts

### asking template.sh
Advanced template for questions in bash scripts.

### box_mount.sh
Mounting Hetzner Storage box via SSHFS. *Change uXXXXX to your Hetzner Box username*. Other options is up to you.

The script is used for fast temporary and safe mounting/unmounting of the Hetzner box. For permanent mounts, use fstab and other faster protocols (SMB/WebDAV).
The script checks for the presence of a directory to mount, the necessary packages and keys. It can also generate ssh keys and copy them to storage.
Root access is not needed. For convenience, the directory is mounted with the permissions of the current user.

### gitpush.sh
Add all files, ask for message, commit it and push to github.

### newssh-key.sh
Create ssh-keys, copy it to new server and create alias for ssh. It will __generate new ssh key pair for every host__. I don't think you need to use it.

### newssh-routine.sh
apt update, upgrade and install some packages on new debian-based server.
