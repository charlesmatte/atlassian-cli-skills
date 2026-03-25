# Sprint & Board Command Reference

## Board Commands

```
acli jira board <action> --site "$ACLI_SITE" [flags]
```

| Action | Description | Key Flags |
|--------|-------------|-----------|
| `list` | List all boards | `--project "PROJ"` (optional filter) |

## Sprint Commands

```
acli jira sprint <action> --site "$ACLI_SITE" --board "BOARD_ID" [flags]
```

| Action | Description | Key Flags |
|--------|-------------|-----------|
| `list` | List sprints | `--state active\|closed\|future` |

## Sprint-Related JQL

| Query | JQL |
|-------|-----|
| Active sprint issues | `sprint in openSprints() AND project = PROJ` |
| Future sprint issues | `sprint in futureSprints() AND project = PROJ` |
| Closed sprint issues | `sprint in closedSprints() AND project = PROJ` |
| Specific sprint | `sprint = "Sprint 42"` |
| Unresolved in sprint | `sprint in openSprints() AND resolution is EMPTY` |

## Typical Workflow

```
1. acli jira board list --site "$ACLI_SITE"
   → Find board ID (e.g., 42)

2. acli jira sprint list --site "$ACLI_SITE" --board 42 --state active
   → Find active sprint details

3. acli jira workitem search --site "$ACLI_SITE" --jql "sprint in openSprints() AND project = PROJ"
   → List all issues in the active sprint
```
