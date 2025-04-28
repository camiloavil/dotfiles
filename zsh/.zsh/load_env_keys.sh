#!/bin/zsh

echo "Loading environment variables to use avante nvim" >&2
export ANTHROPIC_API_KEY=$(pass show key/claude/nvim-code)
