# Admin Command Reference

## Authentication

```
acli admin auth <action> [flags]
```

| Action | Description |
|--------|-------------|
| `login` | Authenticate with API key (`--key "KEY"`) |
| `logout` | End admin session |
| `status` | Check current auth status |
| `switch` | Switch between admin accounts |

## User Management

```
acli admin user <action> [flags]
```

| Action | Description | Key Flags |
|--------|-------------|-----------|
| `list` | List organization users | |
| `activate` | Re-enable a user | `--email "user@example.com"` |
| `deactivate` | Temporarily disable a user | `--email "user@example.com"` |
| `delete` | Permanently remove a user | `--email "user@example.com" --yes` |
| `cancel-delete` | Cancel a pending deletion | `--email "user@example.com"` |

## Field Management

```
acli admin field <action> [flags]
```

| Action | Description | Key Flags |
|--------|-------------|-----------|
| `create` | Create a custom field | `--name "Name" --type "text"` |
| `delete` | Delete a custom field | `--id "FIELD_ID" --yes` |
| `cancel-delete` | Cancel a pending deletion | `--id "FIELD_ID"` |

## Important Notes

- Admin API requires an **API key** (not an API token)
- API keys are created at the organization level
- Admin commands do not use `--site` -- they operate on the entire organization
- Deactivating a user removes their access but preserves their data
- Deleting a user is permanent after the grace period
