source ~/.zsh/functions/check_env.sh

# Create a wrapper function for llm instead of an alias to avoid recursion
llm_wrapper() {
  # Define the environment variable and pass path
  local env_var="OPENAI_API_KEY"
  local pass_path="key/openai/llm-key"

  # First ensure the API key is loaded
  check_env_key "$env_var" "$pass_path"
  # Check if key verification was successful
  if [ $? -ne 0 ]; then
    echo "Error: Failed to set up OpenAI API key. Cannot proceed." >&2
    return 1
  fi
  
  # If there's piped input, capture it and pipe to the real llm command
  if [ -p /dev/stdin ]; then
    cat | command llm "$@"
  else
    # Otherwise just run llm with any provided arguments
    command llm "$@"
  fi
}

