#!/bin/bash

# Directories
SHARE_DIR="$HOME/.local/share/nvim"
STATE_DIR="$HOME/.local/state/nvim"
CACHE_DIR="$HOME/.cache/nvim"

# Function to remove files from a directory
cleanup() {
  local dir=$1
  if [ -d "$dir" ]; then
    echo "Deleting files in $dir"
    rm -rf "$dir"
  else
    echo "Directory $dir does not exist, skipping."
  fi
}

# Clean up each directory
cleanup "$SHARE_DIR"
cleanup "$STATE_DIR"
cleanup "$CACHE_DIR"

echo "Neovim configuration has been reset."
