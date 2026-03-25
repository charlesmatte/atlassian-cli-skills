# Confluence Space Commands Reference

## Command Structure

```
acli confluence space <action> --site "$ACLI_SITE" [flags]
```

## Actions

| Action | Description |
|--------|-------------|
| `list` | List all accessible spaces |
| `view` | View details of a specific space |
| `create` | Create a new space |
| `update` | Update space name, description, or status |
| `archive` | Archive a space |
| `restore` | Restore a space from archive |

## Flags by Action

### `list`

| Flag | Type | Description |
|------|------|-------------|
| `--type` | string | Filter by type: `global` or `personal` |
| `--status` | string | Filter by status: `current` or `archived` |
| `--keys` | string | Comma-separated list of space keys to filter |
| `--limit` | int | Maximum number of results (default: 25) |
| `--expand` | string | Expand fields: `description`, `homepage`, `permissions` |
| `--json` | flag | Output in JSON format |

### `view`

| Flag | Type | Description |
|------|------|-------------|
| `--key` | string | Space key (e.g., `DEV`) |
| `--id` | string | Space ID (numeric) |
| `--desc-format` | string | Description format: `plain` or `view` |
| `--icon` | flag | Include space icon URL |
| `--labels` | flag | Include space labels |
| `--operations` | flag | Include permitted operations |
| `--permissions` | flag | Include space permissions |
| `--properties` | flag | Include space properties |
| `--role-assignments` | flag | Include role assignments |
| `--include-all` | flag | Include all expandable fields |
| `--json` | flag | Output in JSON format |

### `create`

| Flag | Type | Required | Description |
|------|------|----------|-------------|
| `--key` | string | Yes | Space key (uppercase, e.g., `DEV`) |
| `--name` | string | Yes | Space display name |
| `--description` | string | No | Space description |
| `--alias` | string | No | Space alias |
| `--private` | flag | No | Create as a private space |
| `--template-key` | string | No | Template to initialize space from |
| `--json` | flag | No | Output in JSON format |

### `update`

| Flag | Type | Required | Description |
|------|------|----------|-------------|
| `--key` | string | Yes | Space key to update |
| `--name` | string | No | New space name |
| `--description` | string | No | New description |
| `--status` | string | No | New status (`current` or `archived`) |
| `--type` | string | No | Change space type |
| `--json` | flag | No | Output in JSON format |

### `archive` / `restore`

| Flag | Type | Required | Description |
|------|------|----------|-------------|
| `--key` | string | Yes | Space key |

## Space Types

| Type | Description |
|------|-------------|
| `global` | Team or project spaces visible to the organization |
| `personal` | Personal spaces tied to individual users |

## Space Status Values

| Status | Description |
|--------|-------------|
| `current` | Active, accessible space |
| `archived` | Archived space, read-only, hidden from default listings |
