#!/usr/bin/env bash
# Validate bash commands - block dangerous operations
# Exit codes: 0 = allow, 2 = block

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Skip if no command
if [ -z "$COMMAND" ]; then
  exit 0
fi

# Exact dangerous commands to block
DANGEROUS_EXACT=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf /*"
  "rm -rf ~/*"
  ":(){ :|:& };:"
  "> /dev/sda"
  "mkfs"
  "dd if=/dev/zero"
)

for pattern in "${DANGEROUS_EXACT[@]}"; do
  if [[ "$COMMAND" == *"$pattern"* ]]; then
    echo "Blocked: Dangerous command pattern detected: $pattern" >&2
    exit 2
  fi
done

# Block commands that could leak secrets
if [[ "$COMMAND" == *"cat"*".env"* ]] || \
   [[ "$COMMAND" == *"cat"*"secret"* ]] || \
   [[ "$COMMAND" == *"cat"*"password"* ]]; then
  echo "Blocked: Command may expose sensitive data" >&2
  exit 2
fi

# Block curl to suspicious destinations with credentials
if [[ "$COMMAND" == *"curl"* ]] && [[ "$COMMAND" == *"-d"*"password"* ]]; then
  echo "Blocked: Potential credential exfiltration detected" >&2
  exit 2
fi

exit 0
