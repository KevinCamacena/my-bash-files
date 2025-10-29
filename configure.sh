#!/usr/bin/bash

# Get the directory where this script is located

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create symbolic links from home directory to repository files
ln -sf "$SCRIPT_DIR/.bash_aliases" ~/.bash_aliases
ln -sf "$SCRIPT_DIR/.bash_functions" ~/.bash_functions
ln -sf "$SCRIPT_DIR/.bash_k8s" ~/.bash_k8s

ln -sf "$SCRIPT_DIR/.bash_paths" ~/.bash_paths
ln -sf "$SCRIPT_DIR/.bashrc" ~/.bashrc

echo "Dotfiles linked successfully!"
echo "Changes to files in $SCRIPT_DIR will now reflect immediately in your home directory."

# I am copying beacuse I want some level of configuration for each.
# Copying starship.toml to ~/.config
cp starship.toml ~/.config/

