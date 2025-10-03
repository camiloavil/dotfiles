#!/bin/zsh

# echo "Loading check_env_key function" >&2
check_env_key() {
  local pass_path="$1"
  local env_var_name="$2"
  local force_refresh="$3"

  if [[ -z "$pass_path" ]]; then
    echo "Error: Missing parameters. Usage: check_env_key PASS_PATH [ENV_VAR_NAME] [--force]" >&2
    return 1
  fi

  if [[ -z "$env_var_name" ]]; then
    local base
    base=$(basename "$pass_path")
    local derived
    derived=$(printf "%s" "$base" | tr '[:lower:]' '[:upper:]' | tr -cd 'A-Z0-9_')
    if [[ -z "$derived" || ! "$derived" =~ ^[A-Z_][A-Z0-9_]*$ ]]; then
      echo "Error: Could not derive a valid environment variable name from '$pass_path'." >&2
      return 1
    fi
    env_var_name="$derived"
  else
    if ! [[ "$env_var_name" =~ ^[A-Z_][A-Z0-9_]*$ ]]; then
      echo "Error: Provided ENV_VAR_NAME '$env_var_name' is not a valid shell variable name." >&2
      return 1
    fi
  fi

  local current_value
  current_value=""
  # Read current value indirectly if the variable is already set
  if typeset -n _ENV_VAR_REF="$env_var_name" 2>/dev/null; then
    current_value="${_ENV_VAR_REF}"
  fi

  if [[ -z "$current_value" || "$force_refresh" == "--force" ]]; then
    if ! command -v pass &> /dev/null; then
      echo "Error: 'pass' password manager not found. Please install it or set $env_var_name manually." >&2
      return 1
    fi

    echo "Loading $env_var_name from password store..." >&2
    local api_key
    if ! api_key=$(pass show "$pass_path" 2>/dev/null); then
      echo "Error: Could not retrieve key from $pass_path. Please check your password store." >&2
      return 1
    fi

    api_key="$(printf "%s" "$api_key" | head -n1 | tr -d '\r')"
    api_key="${api_key//$'\r'/}"
    api_key="${api_key//$'\n'/}"
    api_key="${api_key#${api_key%%[![:space:]]*}}"
    api_key="${api_key%${api_key##*[![:space:]]*}}"

    # Set the variable name dynamically and export it
    typeset -gx ${env_var_name}="$api_key"
    echo "$env_var_name loaded successfully." >&2
  fi

  return 0
}

