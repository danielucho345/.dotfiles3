#!/bin/bash

# Install stow
yay -S --noconfirm --needed oh-my-posh
sudo pacman -R starship || echo "Unable to uninstall starship"
