#!/usr/bin/env zsh
set -euo pipefail

# Test runner for check_env_key using real pass entries (no mocks)

PASS_CMD=${PASS_CMD:-pass}
if ! command -v "$PASS_CMD" >/dev/null 2>&1; then
  echo "pass is not installed. Skipping tests."
  exit 0
fi

TEST_ENTRY_A="test_check_env/envA"
TEST_ENTRY_B="test_check_env/envB"

# Create two test entries in pass (no mocks). If pass prompts for passphrase, this script will pause.
printf "Creating test entries in pass store...\n"
pass insert "$TEST_ENTRY_A" <<'EOF'
FIRST_LINE_A
VAR1_A:VAL_A1
VAR2_A:VAL_A2
EOF

pass insert "$TEST_ENTRY_B" <<'EOF'
SECOND_LINE_B
VAR1_B:VAL_B1
VAR3_B:VAL_B3
EOF

echo "Running tests..."

# Load function
source /home/camilo/dotfiles/zsh/.zsh/functions/check_env.sh

# Test A
check_env_key "$TEST_ENTRY_A" "" --force
if [[ "$FIRST_LINE_A" != "FIRST_LINE_A" || "$VAR1_A" != "VAL_A1" || "$VAR2_A" != "VAL_A2" ]]; then
  echo "Test A failed: environment not loaded as expected."
  exit 1
fi

# Test B
check_env_key "$TEST_ENTRY_B" "" --force
if [[ "$SECOND_LINE_B" != "SECOND_LINE_B" || "$VAR1_B" != "VAL_B1" || "$VAR3_B" != "VAL_B3" ]]; then
  echo "Test B failed: environment not loaded as expected."
  exit 1
fi

echo "Cleaning up..."
pass rm "$TEST_ENTRY_A" || true
pass rm "$TEST_ENTRY_B" || true

unset FIRST_LINE_A VAR1_A VAR2_A SECOND_LINE_B VAR1_B VAR3_B

echo "All tests passed."
