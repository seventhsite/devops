#!/bin/bash

# Create ssh-keys, copy it to new server and create alias for ssh

# Check user
while true; do
    read -p "Do you want to create keys for user \"$USER\"? Y/n: " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Please run me from user who will use the keys. Bye! "; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

read -p "Please, enter server address to connect: " srvaddress

# Check that keyfile with this name doesn't exist
[[ -f "$HOME"/.ssh/$srvaddress ]] && echo "Looks like you already have the $HOME/.ssh/$srvaddress file." && read -p "Please, enter name for the keyfiles: " keyfilename

echo "We will create an alias for it."
read -p "Please, enter the simple name of new server: " alias

# Check that this alias doesn't used in ssh config
if grep -Fxq "Host $alias " "$HOME"/.ssh/config
then
    echo "Looks like you already use this alias in $HOME/.ssh/config"
    read -p "Please use another simple name: " alias
fi

# Create .ssh directory if doesn't exist
[[ ! -d $HOME/.ssh ]] && echo "You don't have .ssh directory, I'll create it for you." && mkdir "$HOME"/.ssh && chmod 700 "$HOME"/.ssh

# Create new variable keyname from keyfilename or srvaddress (if keyfilename is empty)
[[ -n "$keyfilename" ]] && keyname=$keyfilename || keyname=$srvaddress

echo ""
echo "Let's create a key pair. Password can be blank."
echo ""

ssh-keygen -f "$HOME"/.ssh/"$keyname"

echo ""
echo "Now we will copy the public key to $srvaddress"
echo ""
ssh-copy-id -i "$HOME"/.ssh/"$keyname".pub "$srvaddress"

# If ssh-copy-id exit with error
if [ $? -eq 0 ]; then
    echo ""
else
    echo "ERROR: We can't send public key to $srvaddress. Try it later by yourself."
    echo "Simply add the content of $HOME/.ssh/$keyname.pub to $HOME/.ssh/authorized_keys on your new server"
fi

# Add alias to ssh config
{
    echo "" 
    echo "Host $alias"
    echo "  HostName $srvaddress"
    echo "  IdentityFile $HOME/.ssh/$keyname"
    echo "  User $USER"
} >> "$HOME"/.ssh/config

echo "Done!"
echo "Try \"ssh $alias\""
