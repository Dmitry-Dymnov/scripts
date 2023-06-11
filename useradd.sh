#!/bin/bash
HOME_DIR=/home/
USERNAME_ADD=myuser
GROUP=sudo
GROUPS_ADD=sshadmin
PASSW=Changeme
SSH_KEY_USER='ssh-rsa 
***************************************'
useradd -k /etc/skel/ -m -G$GROUP $USERNAME_ADD && usermod -aG$GROUPS_ADD $USERNAME_ADD && mkdir 
$HOME_DIR$USERNAME_ADD/.ssh && echo $SSH_KEY_USER > $HOME_DIR$USERNAME_ADD/.ssh/authorized_keys && chown -R 
$USERNAME_ADD: $HOME_DIR$USERNAME_ADD/.ssh && chmod 700 $HOME_DIR$USERNAME_ADD/.ssh && chmod 600 
$HOME_DIR$USERNAME_ADD/.ssh/authorized_keys
echo $PASSW | passwd $USERNAME_ADD --stdin