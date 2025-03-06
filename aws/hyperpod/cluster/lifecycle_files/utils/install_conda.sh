#!/bin/bash

set -ex

# Added by Leo
# Set the installation directory

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
sudo ./Miniconda3-latest-Linux-x86_64.sh -b -f -p /opt/miniconda3

sudo chmod -R g+w /opt/miniconda3/

sudo chmod -R g+x /opt/miniconda3/

sudo ln -s /opt/miniconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh

# echo 'export PATH="/opt/miniconda3/bin:$PATH"' >> ~/.bashrc

# source ~/.bashrc