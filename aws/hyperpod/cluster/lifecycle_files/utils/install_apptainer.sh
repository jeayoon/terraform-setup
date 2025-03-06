#!/bin/bash

# Added by Leo
# https://apptainer.org/docs/admin/main/installation.html#install-ubuntu-packages
# Install Ubuntu packages
# For the non-setuid installation use these commands:
sudo add-apt-repository -y ppa:apptainer/ppa
sudo apt update
sudo apt install -y apptainer
