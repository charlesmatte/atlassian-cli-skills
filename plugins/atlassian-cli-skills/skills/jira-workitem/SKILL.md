---
name: jira-workitem
description: "Create, view, edit, transition, and delete Jira issues using ACLI. Supports all issue types, custom fields, comments, attachments, and bulk operations. WHEN: create issue, create ticket, create bug, create story, create task, edit issue, update ticket, move issue, transition issue, change status, delete issue, assign issue, jira task, work item, close ticket, resolve issue, add comment, attach file, jira issue."
license: MIT
metadata:
  author: cmatte
  version: "0.1.0"
---

# Jira Work Items

Full CRUD operations on Jira issues via the Atlassian CLI.

## When to Use This Skill

- User wants to create, view, edit, or delete a Jira issue
- User wants to transition an issue's status (e.g., "move to In Progress")
- User wants to assign, comment on, or add attachments to issues
- User mentions tickets, stories, bugs, tasks, or epics

## Prerequisites

- ACLI installed and authenticated (see **acli-setup**)
- Active profile set (see **acli-profile**) so `$ACLI_SITE` is available

If `$ACLI_SITE` is not set, prompt the user to run `/acli-profile` first.

## Commands

### Create Issue

```bash
acli jira workitem create \
  --site "$ACLI_SITE" \
  --project "PROJECT_KEY" \
  --type "Task" \
  --summary "Issue title here"
```

With description:

```bash
acli jira workitem create \
  --site "$ACLI_SITE" \
  --project "PROJECT_KEY" \
  --type "Bug" \
  --summary "Issue title" \
  --description "Detailed description of the issue"
```

Common types: `Task`, `Bug`, `Story`, `Epic`, `Sub-task`

### View Issue

```bash
acli jira workitem view --site "$ACLI_SITE" --key "PROJ-123"
```

### Edit Issue

```bash
acli jira workitem edit --site "$ACLI_SITE" --key "PROJ-123" \
  --summary "Updated title"
```

Assign to someone:

```bash
acli jira workitem edit --site "$ACLI_SITE" --key "PROJ-123" \
  --assignee "user@example.com"
```

Edit multiple issues:

```bash
acli jira workitem edit --site "$ACLI_SITE" --key "PROJ-123,PROJ-124" \
  --summary "Bulk updated title"
```

### Transition Issue (Change Status)

```bash
acli jira workitem transition --site "$ACLI_SITE" --key "PROJ-123" \
  --status "In Progress"
```

Common transitions: `To Do` -> `In Progress` -> `In Review` -> `Done`

### Delete Issue

```bash
acli jira workitem delete --site "$ACLI_SITE" --key "PROJ-123" --yes
```

### Archive Issue

```bash
acli jira workitem archive --site "$ACLI_SITE" --key "PROJ-123"
```

### Add Comment

```bash
acli jira comment add --site "$ACLI_SITE" --key "PROJ-123" \
  --body "Comment text here"
```

### Add Attachment

```bash
acli jira attachment add --site "$ACLI_SITE" --key "PROJ-123" \
  --file "path/to/file.pdf"
```

### Bulk Operations with JSON

Generate a JSON template:

```bash
acli jira workitem create --site "$ACLI_SITE" --generate-json
```

Create from JSON file:

```bash
acli jira workitem create --site "$ACLI_SITE" --from-json "issues.json"
```

## Rules

1. **Always use `$ACLI_SITE`** -- never hardcode site URLs in commands
2. **Confirm before delete** -- always ask the user before using `--yes` on destructive operations
3. **Confirm before transition** -- tell the user the current and target status before transitioning
4. **Bulk operations** -- process items sequentially and report progress for large batches
5. Use forward slashes in file paths (cross-platform compatible in bash)

## Common Field Reference

See [workitem-commands.md](references/workitem-commands.md) for the full command reference.

## Cross-References

- **jira-search** to find issues before editing
- **jira-sprint** for sprint-related issue operations
- **acli-profile** if `$ACLI_SITE` is not set
- **acli-setup** if ACLI is not installed
