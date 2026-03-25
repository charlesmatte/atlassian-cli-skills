# Profile Schema

## File Location

`~/.config/acli-claude/profiles.json`

This path works cross-platform:
- **macOS/Linux**: `$HOME/.config/acli-claude/profiles.json`
- **Windows (Git Bash/WSL)**: `$HOME/.config/acli-claude/profiles.json`
- **Windows (PowerShell)**: `$env:USERPROFILE\.config\acli-claude\profiles.json`

## Schema

```json
{
  "active": "profile-name",
  "profiles": {
    "profile-name": {
      "site": "mysite.atlassian.net",
      "email": "user@example.com",
      "token": "ATATT3xFfGF0...",
      "description": "Human-readable description"
    }
  }
}
```

## Fields

### Top-level

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `active` | string | Yes | Name of the currently active profile. Empty string if none. |
| `profiles` | object | Yes | Map of profile name to profile configuration. |

### Profile object

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `site` | string | Yes | Atlassian site hostname (e.g., `mycompany.atlassian.net`) |
| `email` | string | Yes | Email address for authentication |
| `token` | string | No | Atlassian API token for REST API calls (Confluence page CRUD, CQL search). Same token used for `acli auth login`. |
| `description` | string | No | Human-readable label for the profile |

## Environment Variables

When a profile is active, the following environment variables are set in `$CLAUDE_ENV_FILE`:

| Variable | Example | Description |
|----------|---------|-------------|
| `ACLI_ACTIVE_PROFILE` | `work` | Name of the active profile |
| `ACLI_SITE` | `mycompany.atlassian.net` | Site hostname for `--site` flag |
| `ACLI_EMAIL` | `user@company.com` | Email for reference |
| `ACLI_TOKEN` | `ATATT3x...` | API token for REST API calls (Confluence). Only set if `token` is present in the profile. |

## Validation Rules

- Profile names: alphanumeric and hyphens only (`^[a-zA-Z0-9-]+$`)
- Site: must be a valid hostname (typically `*.atlassian.net`)
- Email: must be a valid email address
- At most one profile can be active at a time
