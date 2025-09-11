#!/usr/bin/env zsh

# Show a banner with the name of the current folder
current_folder=$(basename "$PWD")
pyfiglet -c RED -f slant "        $current_folder"

# Function to run in the new tmux window
load_local_init() {
  # Check if local init.sh exists and source it
  if [[ -f "init.sh" ]]; then
      echo "Loading from local init.sh..."
      source init.sh
  fi
}

load_local_init
