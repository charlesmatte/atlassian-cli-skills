---
name: jira-search
description: "Search Jira issues using JQL queries, manage saved filters, and list results. WHEN: search jira, find issues, jql, query jira, filter issues, list tickets, my issues, assigned to me, open bugs, sprint backlog, jira filter, search tickets, find bugs, recent issues, unassigned issues."
license: MIT
metadata:
  author: cmatte
  version: "0.1.0"
---

# Jira Search

JQL-powered search and filter management for Jira.

## When to Use This Skill

- User wants to search or query Jira issues
- User asks for "my issues", "open bugs", "recent tickets", etc.
- User mentions JQL or filters
- User wants to list issues matching criteria

## Prerequisites

- ACLI installed and authenticated (see **acli-setup**)
- Active profile set (see **acli-profile**) so `$ACLI_SITE` is available

## Commands

### Search with JQL

```bash
acli jira workitem search --site "$ACLI_SITE" \
  --jql "project = PROJ AND status = 'In Progress' ORDER BY updated DESC"
```

### Search with Saved Filter

```bash
acli jira workitem search --site "$ACLI_SITE" --filter "FILTER_ID"
```

### List Saved Filters

```bash
acli jira filter list --site "$ACLI_SITE"
```

### View Filter Details

```bash
acli jira filter show --site "$ACLI_SITE" --id "FILTER_ID"
```

## Common JQL Patterns

Translate natural language requests to JQL:

| User Says | JQL |
|-----------|-----|
| "my open issues" | `assignee = currentUser() AND status != Done ORDER BY updated DESC` |
| "open bugs in PROJECT" | `project = PROJECT AND type = Bug AND status != Done ORDER BY priority DESC` |
| "issues created this week" | `created >= startOfWeek() ORDER BY created DESC` |
| "sprint backlog" | `sprint in openSprints() AND project = PROJECT ORDER BY rank ASC` |
| "unassigned in PROJECT" | `project = PROJECT AND assignee is EMPTY ORDER BY created DESC` |
| "recently updated" | `updated >= -7d ORDER BY updated DESC` |
| "high priority bugs" | `type = Bug AND priority in (Highest, High) AND status != Done` |
| "issues assigned to USER" | `assignee = "user@example.com" ORDER BY updated DESC` |
| "epics in PROJECT" | `project = PROJECT AND type = Epic ORDER BY rank ASC` |
| "done this month" | `status = Done AND resolved >= startOfMonth() ORDER BY resolved DESC` |

See [jql-guide.md](references/jql-guide.md) for the full JQL syntax reference.

## Rules

1. **Always use `$ACLI_SITE`** from the active profile
2. Default to `ORDER BY updated DESC` if the user doesn't specify an order
3. For large result sets, suggest adding filters to narrow results
4. When the user describes issues in natural language, translate to JQL
5. Quote string values in JQL with single quotes (e.g., `status = 'In Progress'`)

## Cross-References

- **jira-workitem** to act on found issues (edit, transition, delete)
- **jira-sprint** for sprint-scoped queries
- **acli-profile** if `$ACLI_SITE` is not set
