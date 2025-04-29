#!/bin/zsh

source ~/.zsh/functions/check_env.sh

echo "Loading environment variables to use avante nvim" >&2
check_env_key 'ANTHROPIC_API_KEY' 'key/claude/nvim-code'
