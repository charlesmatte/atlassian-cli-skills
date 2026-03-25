# Jira Work Item Command Reference

## Command Structure

```
acli jira workitem <action> --site "$ACLI_SITE" [flags]
```

## Actions

| Action | Description |
|--------|-------------|
| `create` | Create a new issue |
| `view` | View issue details |
| `edit` | Update issue fields |
| `transition` | Change issue status |
| `delete` | Delete an issue |
| `archive` | Archive an issue |
| `search` | Search issues (see jira-search skill) |

## Common Flags

| Flag | Description | Example |
|------|-------------|---------|
| `--site` | Atlassian site | `--site "$ACLI_SITE"` |
| `--key` | Issue key(s) | `--key "PROJ-123"` or `--key "PROJ-123,PROJ-124"` |
| `--project` | Project key | `--project "PROJ"` |
| `--type` | Issue type | `--type "Task"` |
| `--summary` | Issue title | `--summary "Fix login bug"` |
| `--description` | Issue body | `--description "Details here"` |
| `--assignee` | Assignee email | `--assignee "user@example.com"` |
| `--status` | Target status (transition) | `--status "Done"` |
| `--yes` | Skip confirmation | `--yes` |
| `--from-json` | Input from JSON file | `--from-json "issues.json"` |
| `--from-file` | Input from text file | `--from-file "desc.txt"` |
| `--generate-json` | Generate JSON template | `--generate-json` |

## Comment Commands

```
acli jira comment <action> --site "$ACLI_SITE" --key "PROJ-123" [flags]
```

| Action | Description |
|--------|-------------|
| `add` | Add a comment (`--body "text"`) |
| `list` | List comments on an issue |
| `delete` | Delete a comment |

## Attachment Commands

```
acli jira attachment <action> --site "$ACLI_SITE" --key "PROJ-123" [flags]
```

| Action | Description |
|--------|-------------|
| `add` | Attach a file (`--file "path"`) |
| `list` | List attachments |
| `delete` | Delete an attachment |

## Issue Types

Standard Jira Cloud issue types:
- `Task` -- General work item
- `Bug` -- Defect or error
- `Story` -- User story
- `Epic` -- Large body of work
- `Sub-task` -- Child of another issue

Custom types vary by project configuration.
