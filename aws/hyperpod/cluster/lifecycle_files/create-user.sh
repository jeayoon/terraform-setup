cat > create-user.sh << EOL
#!/bin/bash

set -x

# Prompt user to get the new user name.
read -p "Enter the new user name, i.e. 'sean': " USER

# Prompt for new group name
read -p "Enter the new group name, i.e. 'developers': " GROUP

# Check if the group exists, create it if it doesn't
if ! getent group \$GROUP > /dev/null; then
    sudo groupadd \$GROUP
    echo "Group '\$GROUP' created."
else
    echo "Group '\$GROUP' already exists."
fi

# create home directory as /fsx/<user>
# Create the new user on the head node
sudo useradd \$USER -m -d /fsx/\$USER --shell /bin/bash;
user_id=\$(id -u \$USER)

# add user to docker group
sudo usermod -aG docker \${USER}

# add user to created group
sudo usermod -aG \${GROUP} \${USER}

# setup SSH Keypair
sudo -u \$USER ssh-keygen -t rsa -q -f "/fsx/\$USER/.ssh/id_rsa" -N ""
sudo -u \$USER cat /fsx/\$USER/.ssh/id_rsa.pub | sudo -u \$USER tee /fsx/\$USER/.ssh/authorized_keys

# change the .ssh owner
sudo chown -R \$USER:\$USER /fsx/\$USER/.ssh

# add user to compute nodes
read -p "Number of compute nodes in your cluster, i.e. 8: 
" NUM_NODES
srun -N \$NUM_NODES sudo useradd -u \$user_id \$USER -d /fsx/\$USER --shell /bin/bash;

# add them as a sudoer
read -p "Do you want this user to be a sudoer? (y/N):
" SUDO
if [ "\$SUDO" = "y" ]; then
        sudo usermod -aG sudo \$USER
        sudo srun -N \$NUM_NODES sudo usermod -aG sudo \$USER
        echo -e "If you haven't already you'll need to run:\n\nsudo visudo /etc/sudoers\n\nChange the line:\n\n%sudo   ALL=(ALL:ALL) ALL\n\nTo\n\n%sudo   ALL=(ALL:ALL) NOPASSWD: ALL\n\nOn each node."
fi
EOL