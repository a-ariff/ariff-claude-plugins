#!/usr/bin/env bash
# Validate file write operations - block writes to sensitive files
# Exit codes: 0 = allow, 2 = block

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty')

# Skip if no file path
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Block writes to sensitive files
SENSITIVE_PATTERNS=(
  "*.env"
  "*secret*"
  "*password*"
  "*credentials*"
  "*.pem"
  "*.key"
  "*/.ssh/*"
  "*/.aws/*"
)

for pattern in "${SENSITIVE_PATTERNS[@]}"; do
  if [[ "$FILE_PATH" == $pattern ]]; then
    echo "Blocked: Cannot write to sensitive file matching pattern '$pattern'" >&2
    exit 2
  fi
done

# Block writes to system directories
if [[ "$FILE_PATH" == /etc/* ]] || \
   [[ "$FILE_PATH" == /usr/* ]] || \
   [[ "$FILE_PATH" == /bin/* ]] || \
   [[ "$FILE_PATH" == /sbin/* ]]; then
  echo "Blocked: Cannot write to system directory" >&2
  exit 2
fi

exit 0
