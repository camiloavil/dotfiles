#!/bin/zsh

check_env_key() {
  # Generic function to retrieve and set an API key from password store
  # Parameters:
  #   $1: Environment variable name (e.g., "OPENAI_API_KEY")
  #   $2: Pass path to key (e.g., "key/openai/llm-key")
  #   $3: (Optional) "--force" to force refresh the key
  
  local env_var_name="$1"
  local pass_path="$2"
  local force_refresh="$3"
  
  # Check if parameters are provided
  if [[ -z "$env_var_name" || -z "$pass_path" ]]; then
    echo "Error: Missing parameters. Usage: check_env_key ENV_VAR_NAME PASS_PATH [--force]" >&2
    return 1
  fi

  # Get the current value of the environment variable
  local current_value
  eval "current_value=\${$env_var_name}"
  
  # Check if key needs to be loaded
  if [[ -z "$current_value" || "$force_refresh" == "--force" ]]; then
    # Check if pass is installed
    if ! command -v pass &> /dev/null; then
      echo "Error: 'pass' password manager not found. Please install it or set $env_var_name manually." >&2
      return 1
    fi
    
    # Try to load the API key from pass
    echo "Loading $env_var_name from password store..." >&2
    local api_key
    if ! api_key=$(pass show "$pass_path" 2>/dev/null); then
      echo "Error: Could not retrieve key from $pass_path. Please check your password store." >&2
      return 1
    fi
    
    # Set the API key
    eval "export $env_var_name='$api_key'"
    echo "$env_var_name loaded successfully." >&2
  fi
  
  return 0
}

