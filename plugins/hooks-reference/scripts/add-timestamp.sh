#!/usr/bin/env bash
# Add timestamp to user prompts
# Provides Claude with current time context

set -euo pipefail

# Plain text output is added as context to the prompt
echo "Current time: $(date '+%Y-%m-%d %H:%M:%S %Z')"

exit 0
