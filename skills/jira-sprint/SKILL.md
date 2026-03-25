---
name: jira-sprint
description: "Manage Jira sprints, boards, and agile workflows. View sprint progress, list boards, and query sprint backlogs. WHEN: sprint, board, backlog, agile, scrum, kanban, sprint planning, sprint review, velocity, active sprint, sprint issues, board list, sprint progress."
license: MIT
metadata:
  author: cmatte
  version: "0.1.0"
---

# Jira Sprints & Boards

Sprint and board management for agile workflows.

## When to Use This Skill

- User asks about sprints, boards, or backlogs
- User wants to view sprint progress or sprint contents
- User mentions agile, scrum, or kanban workflows
- User asks "what's in the current sprint?"

## Prerequisites

- ACLI installed and authenticated (see **acli-setup**)
- Active profile set (see **acli-profile**) so `$ACLI_SITE` is available

## Commands

### List Boards

```bash
acli jira board list --site "$ACLI_SITE"
```

Filter by project:

```bash
acli jira board list --site "$ACLI_SITE" --project "PROJ"
```

### List Sprints for a Board

```bash
acli jira sprint list --site "$ACLI_SITE" --board "BOARD_ID"
```

Active sprints only:

```bash
acli jira sprint list --site "$ACLI_SITE" --board "BOARD_ID" --state active
```

### View Sprint Issues

Use JQL to query issues in active sprints:

```bash
acli jira workitem search --site "$ACLI_SITE" \
  --jql "sprint in openSprints() AND project = PROJ ORDER BY rank ASC"
```

Issues in a specific sprint:

```bash
acli jira workitem search --site "$ACLI_SITE" \
  --jql "sprint = 'Sprint Name' ORDER BY rank ASC"
```

### Sprint Backlog (Unstarted Items)

```bash
acli jira workitem search --site "$ACLI_SITE" \
  --jql "sprint in openSprints() AND project = PROJ AND status = 'To Do' ORDER BY rank ASC"
```

### Sprint Progress (In-Flight Items)

```bash
acli jira workitem search --site "$ACLI_SITE" \
  --jql "sprint in openSprints() AND project = PROJ AND status = 'In Progress' ORDER BY rank ASC"
```

### Completed in Sprint

```bash
acli jira workitem search --site "$ACLI_SITE" \
  --jql "sprint in openSprints() AND project = PROJ AND status = Done ORDER BY resolved DESC"
```

## Workflow

1. **List boards** to find the board ID for the project
2. **List sprints** on that board to see active/future sprints
3. **Query sprint issues** using JQL with `sprint in openSprints()`

## Rules

1. **Always use `$ACLI_SITE`** from the active profile
2. Board ID is required for sprint operations -- list boards first if unknown
3. When the user asks about "the sprint", default to active/open sprints
4. For sprint-scoped issue queries, prefer JQL via **jira-search** patterns

## Cross-References

- **jira-workitem** to create/edit issues within a sprint
- **jira-search** for the full JQL syntax reference
- **acli-profile** if `$ACLI_SITE` is not set
