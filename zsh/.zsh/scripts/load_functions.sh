#!/bin/zsh

echo "Loading my zsh functions" >&2

# llm_wrapper loads check_env_key
source ~/.zsh/functions/llm_wrapper.sh
# source ~/.zsh/functions/check_env.sh
source ~/.zsh/functions/autocommit.sh

# check_env_key 'ANTHROPIC_API_KEY' 'key/claude/nvim-code'
