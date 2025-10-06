#!/bin/zsh

# English description: load an API key from a password store and export env vars
# - PASS_PATH: path to the password store entry (required)
# - ENV_VAR_NAME: optional; if omitted, derived from basename(PASS_PATH)
# - --force: optional; force reload of the key
check_env_key() {
  local pass_path="$1"
  local env_var_name="$2"
  local force_refresh="$3"

  if [[ -z "$pass_path" ]]; then
    echo "Error: Missing parameters. Usage: check_env_key PASS_PATH [ENV_VAR_NAME] [--force]" >&2
    return 1
  fi

  local base
  base=$(basename "$pass_path")

  # Derive env_var_name if not provided
  if [[ -z "$env_var_name" ]]; then
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

  local current_value=""
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

    # First line is the main env var
    local first_line
    first_line="$(printf "%s" "$api_key" | head -n1 | tr -d '\r')"
    
    # Export main var
    typeset -gx "${env_var_name}"="$first_line"
    echo "$env_var_name loaded successfully." >&2

    # Process remaining lines for KEY:VALUE
    local rest
    rest=$(printf "%s" "$api_key" | tail -n +2)
    if [[ -n "$rest" ]]; then
      local _base="$base"
      while IFS= read -r line; do
        line="$(printf "%s" "$line" | tr -d '[:space:]\t')"
        # Trim whitespace
        line="${line##[[:space:]]*}"
        line="${line%%*[[:space:]]}"
        [[ -z "$line" || "$line" =~ ^#.* ]] && continue
        if [[ "$line" == *":"* ]]; then
          local key="${line%%:*}"
          local val="${line#*:}"
          key="${key##[[:space:]]*}"
          key="${key%%*[[:space:]]}"
          val="${val##[[:space:]]*}"
          val="${val%%*[[:space:]]}"
          local key_norm
          key_norm=$(printf "%s" "$key" | tr '[:lower:]' '[:upper:]' | tr -cd 'A-Z0-9_')
          if [[ -n "$key_norm" ]]; then
            local var_name="${_base}_${key_norm}"
            var_name=$(printf "%s" "$var_name" | tr '[:lower:]' '[:upper:]' | tr -cd 'A-Z0-9_')
            if [[ -n "$var_name" && "$var_name" =~ ^[A-Z_][A-Z0-9_]*$ ]]; then
              typeset -gx "${var_name}"="$val"
              echo "$var_name loaded from multiline." >&2
            fi
          fi
        fi
      done <<< "$rest"
    fi
  fi

  return 0
}
