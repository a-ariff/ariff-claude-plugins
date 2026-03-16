#!/bin/bash
# Scan response for speculative language patterns
# Used as a reference -- the prompt-based hook handles the actual checking

SPECULATIVE_PATTERNS=(
  "I think"
  "I believe"
  "probably"
  "likely"
  "should work"
  "might be"
  "could be"
  "as far as I know"
  "if I recall"
  "I assume"
  "presumably"
  "it seems like"
  "I expect"
  "typically"
  "usually"
)

INPUT=$(cat)

FOUND=0
for pattern in "${SPECULATIVE_PATTERNS[@]}"; do
  if echo "$INPUT" | grep -qi "$pattern"; then
    echo "SPECULATIVE: Found '$pattern' in response" >&2
    FOUND=$((FOUND + 1))
  fi
done

if [ $FOUND -gt 0 ]; then
  echo '{"result": "warn", "reason": "Response contains '$FOUND' speculative phrases that may indicate unverified claims"}'
  exit 0
fi

echo '{"result": "ok"}'
exit 0
