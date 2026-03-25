#!/usr/bin/env bash
# Loads the active ACLI profile into CLAUDE_ENV_FILE on session start.
# Cross-platform: works on macOS, Linux, and Windows (Git Bash / WSL).
set +e

PROFILES_DIR="$HOME/.config/acli-claude"
PROFILES_FILE="$PROFILES_DIR/profiles.json"

# If no profiles file exists, nothing to load
if [ ! -f "$PROFILES_FILE" ]; then
  exit 0
fi

# Detect python command (python3 on macOS/Linux, python on Windows)
PYTHON=$(command -v python3 2>/dev/null || command -v python 2>/dev/null)
if [ -z "$PYTHON" ]; then
  exit 0
fi

# Read active profile and write env vars
ENVVARS=$($PYTHON -c "
import json, sys, os
path = os.path.expanduser('~/.config/acli-claude/profiles.json')
try:
    data = json.load(open(path))
except Exception:
    sys.exit(0)
active = data.get('active', '')
if not active or active not in data.get('profiles', {}):
    sys.exit(0)
p = data['profiles'][active]
print(f'export ACLI_ACTIVE_PROFILE=\"{active}\"')
print(f'export ACLI_SITE=\"{p.get(\"site\", \"\")}\"')
print(f'export ACLI_EMAIL=\"{p.get(\"email\", \"\")}\"')
token = p.get('token', '')
if token:
    print(f'export ACLI_TOKEN=\"{token}\"')
" 2>/dev/null)

# Write to CLAUDE_ENV_FILE if available
if [ -n "$CLAUDE_ENV_FILE" ] && [ -n "$ENVVARS" ]; then
  echo "$ENVVARS" >> "$CLAUDE_ENV_FILE"
fi

exit 0
