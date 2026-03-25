---
name: acli-profile
description: "Manage multiple Atlassian site profiles for switching between Jira instances within a Claude Code session. Create, list, switch, show, and delete named profiles. WHEN: switch profile, change site, switch jira, switch atlassian, add profile, list profiles, which profile, current site, multi-site, multi-tenant, acli profile, add account, switch account."
license: MIT
metadata:
  author: cmatte
  version: "0.1.0"
---

# ACLI Profile Manager

Manages named profiles for multiple Atlassian sites/accounts, enabling seamless switching within a single Claude Code session.

## When to Use This Skill

- User wants to switch between Atlassian sites
- User asks "which site am I on?" or "what profile is active?"
- User wants to add, list, or remove a site profile
- User mentions multi-site, multi-tenant, or profile switching
- Another skill reports `$ACLI_SITE` is not set

## Architecture

Profiles are stored in `~/.config/acli-claude/profiles.json`. The active profile's `site` and `email` are written to `$CLAUDE_ENV_FILE` so all subsequent ACLI commands automatically target the correct site.

See [profile-schema.md](references/profile-schema.md) for the JSON schema.

## Operations

### Show Current Profile

```bash
PYTHON=$(command -v python3 2>/dev/null || command -v python 2>/dev/null)
$PYTHON -c "
import json, os, sys
path = os.path.expanduser('~/.config/acli-claude/profiles.json')
try:
    data = json.load(open(path))
except FileNotFoundError:
    print('No profiles configured. Use /acli-profile to create one.')
    sys.exit(0)
active = data.get('active', '')
if active and active in data.get('profiles', {}):
    p = data['profiles'][active]
    print(f'Active profile: {active}')
    print(f'  Site:  {p[\"site\"]}')
    print(f'  Email: {p[\"email\"]}')
    print(f'  Desc:  {p.get(\"description\", \"\")}')
else:
    print('No active profile set.')
"
```

### List All Profiles

```bash
PYTHON=$(command -v python3 2>/dev/null || command -v python 2>/dev/null)
$PYTHON -c "
import json, os
path = os.path.expanduser('~/.config/acli-claude/profiles.json')
try:
    data = json.load(open(path))
except FileNotFoundError:
    print('No profiles configured.')
    raise SystemExit(0)
active = data.get('active', '')
for name, p in data.get('profiles', {}).items():
    marker = ' (active)' if name == active else ''
    print(f'{name}{marker}: {p[\"site\"]} ({p[\"email\"]})')
"
```

### Create Profile

Replace `PROFILE_NAME`, `SITE`, `EMAIL`, and `DESCRIPTION` with actual values from the user.

```bash
PYTHON=$(command -v python3 2>/dev/null || command -v python 2>/dev/null)
$PYTHON -c "
import json, os
path = os.path.expanduser('~/.config/acli-claude/profiles.json')
os.makedirs(os.path.dirname(path), exist_ok=True)
try:
    data = json.load(open(path))
except (FileNotFoundError, json.JSONDecodeError):
    data = {'active': '', 'profiles': {}}
data['profiles']['PROFILE_NAME'] = {
    'site': 'SITE.atlassian.net',
    'email': 'EMAIL',
    'token': 'TOKEN',
    'description': 'DESCRIPTION'
}
# Note: 'token' is optional. Omit the key or set to '' if the user does not provide one.
if not data['active']:
    data['active'] = 'PROFILE_NAME'
json.dump(data, open(path, 'w'), indent=2)
print('Profile PROFILE_NAME created.')
"
```

After creating, if this is the first or active profile, update the session environment:

```bash
echo "export ACLI_ACTIVE_PROFILE=\"PROFILE_NAME\"" >> "$CLAUDE_ENV_FILE"
echo "export ACLI_SITE=\"SITE.atlassian.net\"" >> "$CLAUDE_ENV_FILE"
echo "export ACLI_EMAIL=\"EMAIL\"" >> "$CLAUDE_ENV_FILE"
# Only export ACLI_TOKEN if the user provided a token:
echo "export ACLI_TOKEN=\"TOKEN\"" >> "$CLAUDE_ENV_FILE"
```

### Switch Profile

Replace `TARGET_PROFILE` with the profile name.

```bash
PYTHON=$(command -v python3 2>/dev/null || command -v python 2>/dev/null)
$PYTHON -c "
import json, os, sys
path = os.path.expanduser('~/.config/acli-claude/profiles.json')
data = json.load(open(path))
target = 'TARGET_PROFILE'
if target not in data.get('profiles', {}):
    print(f'Profile \"{target}\" not found. Available: {list(data[\"profiles\"].keys())}')
    sys.exit(1)
data['active'] = target
json.dump(data, open(path, 'w'), indent=2)
p = data['profiles'][target]
print(f'Switched to {target}: {p[\"site\"]} ({p[\"email\"]})')
"

# Update session environment immediately
echo "export ACLI_ACTIVE_PROFILE=\"TARGET_PROFILE\"" >> "$CLAUDE_ENV_FILE"
echo "export ACLI_SITE=\"SITE\"" >> "$CLAUDE_ENV_FILE"
echo "export ACLI_EMAIL=\"EMAIL\"" >> "$CLAUDE_ENV_FILE"
# Only export ACLI_TOKEN if the profile has a token:
echo "export ACLI_TOKEN=\"TOKEN\"" >> "$CLAUDE_ENV_FILE"
```

### Delete Profile

Replace `PROFILE_NAME` with the profile to delete. Always confirm with the user first.

```bash
PYTHON=$(command -v python3 2>/dev/null || command -v python 2>/dev/null)
$PYTHON -c "
import json, os
path = os.path.expanduser('~/.config/acli-claude/profiles.json')
data = json.load(open(path))
name = 'PROFILE_NAME'
if name in data.get('profiles', {}):
    del data['profiles'][name]
    if data.get('active') == name:
        data['active'] = next(iter(data['profiles']), '')
    json.dump(data, open(path, 'w'), indent=2)
    print(f'Profile \"{name}\" deleted.')
    if data['active']:
        print(f'Active profile is now: {data[\"active\"]}')
else:
    print(f'Profile \"{name}\" not found.')
"
```

## Rules

1. Always confirm with the user before deleting a profile
2. When switching, immediately update `$CLAUDE_ENV_FILE` so subsequent commands use the new site
3. Profile names must be alphanumeric with hyphens (no spaces)
4. The `site` field should be a valid Atlassian site (e.g., `mysite.atlassian.net`)
5. Use the cross-platform Python detection pattern: `$(command -v python3 2>/dev/null || command -v python 2>/dev/null)`
6. The `token` field is optional. It is only needed for Confluence page create/update/delete and CQL search operations that use the REST API directly. If the user does not provide a token, omit the field or leave it empty.

## Cross-References

- Use **acli-setup** if ACLI is not installed or no authentication exists
- All Jira skills (**jira-workitem**, **jira-search**, **jira-sprint**) read `$ACLI_SITE` automatically
- Confluence skills (**confluence-space**, **confluence-page**, **confluence-search**) read `$ACLI_SITE` and `$ACLI_TOKEN`
- **admin-user** reads profile info for admin operations
