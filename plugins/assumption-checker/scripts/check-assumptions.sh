#!/usr/bin/env bash
# Assumption checker - WARNS only, never blocks (exit 0 always)
# Strict Canvas verification required when course context detected

set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input | tostring' 2>/dev/null || echo "")

WARNINGS=""

# Check for assumption language
if echo "$TOOL_INPUT" | grep -qiE "(assume|probably|might|should work|i think|maybe|likely)"; then
  WARNINGS+="⚠️ Assumption language detected - please verify before proceeding.\n"
fi

# Canvas context detection - STRICT VERIFICATION REQUIRED
CANVAS_KEYWORDS="canvas|course|assignment|grade|submission|due date|rubric|IT8107|IT8109|IT8101|IT8102|IT8103|IT8106|whitecliffe|learn\.mywhitecliffe"
if echo "$TOOL_INPUT" | grep -qiE "$CANVAS_KEYWORDS"; then
  WARNINGS+="📚 CANVAS CONTEXT DETECTED!\n"
  WARNINGS+="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
  WARNINGS+="→ You MUST use Canvas MCP tools to verify:\n"
  WARNINGS+="  • get_courses - List all courses\n"
  WARNINGS+="  • get_assignments - Get assignments for course\n"
  WARNINGS+="  • get_grades - Check current grades\n"
  WARNINGS+="  • get_submissions - Check submission status\n"
  WARNINGS+="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
  WARNINGS+="→ User ID: 2396 (Ariff)\n"
  WARNINGS+="→ Current Courses: IT8107 (2366), IT8109 (2368)\n"
  WARNINGS+="→ Do NOT assume any course/assignment/grade details!\n"
  WARNINGS+="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
fi

# High-stakes operations warning (warn only, no block)
if [[ "$TOOL_NAME" == "Bash" ]]; then
  if echo "$TOOL_INPUT" | grep -qiE "(rm -rf|drop table|delete from|production|deploy)"; then
    WARNINGS+="🔴 HIGH-STAKES OPERATION - Double-check before proceeding!\n"
  fi
  if echo "$TOOL_INPUT" | grep -qiE "(credential|password|secret|api.key|token)"; then
    WARNINGS+="🔐 CREDENTIAL OPERATION - Verify this is intentional!\n"
  fi
fi

# Database operations warning
if [[ "$TOOL_NAME" == "Bash" ]] || [[ "$TOOL_NAME" == "Write" ]]; then
  if echo "$TOOL_INPUT" | grep -qiE "(insert into|update.*set|delete from|alter table|drop)"; then
    WARNINGS+="🗄️ DATABASE OPERATION - Verify data integrity!\n"
  fi
fi

# Output warnings (exit 0 = proceed, but show context to Claude)
if [ -n "$WARNINGS" ]; then
  echo -e "$WARNINGS"
fi

# Always exit 0 - we warn but never block
exit 0
