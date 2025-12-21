---
name: systematic-debugging
description: Structured approach to finding and fixing bugs
version: 1.0.0
author: Ariff
when_to_use: When debugging - follow systematic process instead of guessing
---

# Systematic Debugging

## The Process

```
REPRODUCE → ISOLATE → TRACE → FIX → VERIFY
```

Never skip steps. Never guess.

## Step 1: Reproduce

**Goal:** See the bug happen reliably

```
1. Get exact reproduction steps
2. Run them yourself
3. See the exact error
4. Document: input, output, expected
```

**Red flags:**
- "It happens sometimes" → Find the condition
- "I can't reproduce" → Get more details from reporter
- Skipping this step → You'll waste time guessing

## Step 2: Isolate

**Goal:** Find minimum case that shows bug

```
1. Start removing things
2. Does bug still happen?
3. Keep removing until minimal
4. Result: smallest repro case
```

**Why this matters:**
- Smaller case = easier to debug
- Reveals what's actually involved
- Eliminates red herrings

## Step 3: Trace

**Goal:** Find root cause (use root-cause-tracing skill)

```
1. Start at symptom
2. Trace backward: where does bad value come from?
3. Keep asking "where did THIS come from?"
4. Stop when you find origin
```

**Tools:**
- Print/log statements
- Debugger breakpoints
- Code reading
- Test isolation

## Step 4: Fix

**Goal:** Change code at root cause

```
1. Write failing test first
2. Make minimal change to fix
3. Verify test passes
4. Check for side effects
```

**Anti-patterns:**
- Big refactor during bugfix
- Fixing symptoms not cause
- No test for the fix

## Step 5: Verify

**Goal:** Confirm fix works and nothing broke

```
1. Run original reproduction
2. Bug should be gone
3. Run full test suite
4. No regressions
```

**Must have:**
- Fresh reproduction attempt
- All tests passing
- No new warnings/errors

## Common Bug Types

| Type | Debug Strategy |
|------|---------------|
| Null/undefined | Trace where value should've been set |
| Wrong value | Log at each transformation step |
| Race condition | Add logging with timestamps |
| State corruption | Find all state modifiers |
| Off-by-one | Check loop bounds and indices |
| Missing case | Check all switch/if branches |

## Debug Log Pattern

When adding debug logs:

```javascript
// Include: location, variable name, value, timestamp
console.log('[user.ts:45]', 'userId:', userId, Date.now());
```

Clean up logs before committing.

## Bisect Strategy

When you don't know what broke it:

```
1. Find last known working version
2. Find first broken version
3. Binary search between them
4. Each step: does bug exist?
5. Result: exact commit that broke it
```

## Integration with Skills

- `root-cause-tracing` → For step 3 (Trace)
- `defense-in-depth` → For step 5 (Verify)
- `verification-before-completion` → Before claiming fixed

## Integration with Checkers

- `assumption-checker` → What assumptions about the code?
- `fact-checker` → Verify claims about behavior
- `pre-action-verifier` → Before applying fix
