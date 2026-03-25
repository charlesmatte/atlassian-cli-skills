# JQL Quick Reference

## Syntax

```
field operator value [AND|OR field operator value ...] [ORDER BY field [ASC|DESC]]
```

## Common Fields

| Field | Description | Example |
|-------|-------------|---------|
| `project` | Project key | `project = PROJ` |
| `type` | Issue type | `type = Bug` |
| `status` | Workflow status | `status = "In Progress"` |
| `assignee` | Assigned user | `assignee = currentUser()` |
| `reporter` | Issue creator | `reporter = "user@example.com"` |
| `priority` | Issue priority | `priority = High` |
| `created` | Creation date | `created >= -7d` |
| `updated` | Last modified | `updated >= startOfWeek()` |
| `resolved` | Resolution date | `resolved >= startOfMonth()` |
| `sprint` | Sprint name/id | `sprint in openSprints()` |
| `labels` | Issue labels | `labels = "backend"` |
| `component` | Components | `component = "API"` |
| `fixVersion` | Fix version | `fixVersion = "1.0"` |
| `text` | Full text search | `text ~ "login error"` |
| `summary` | Title search | `summary ~ "auth"` |
| `description` | Body search | `description ~ "timeout"` |

## Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `=` | Equals | `status = Done` |
| `!=` | Not equals | `status != Done` |
| `>`, `<`, `>=`, `<=` | Comparison | `created >= -7d` |
| `in` | In list | `status in (Open, "In Progress")` |
| `not in` | Not in list | `priority not in (Low, Lowest)` |
| `~` | Contains text | `summary ~ "auth"` |
| `!~` | Does not contain | `summary !~ "test"` |
| `is` | Is value | `assignee is EMPTY` |
| `is not` | Is not value | `assignee is not EMPTY` |
| `was` | Previously was | `status was "In Progress"` |
| `changed` | Field changed | `status changed` |

## Functions

| Function | Description |
|----------|-------------|
| `currentUser()` | Logged-in user |
| `openSprints()` | Currently active sprints |
| `closedSprints()` | Completed sprints |
| `futureSprints()` | Upcoming sprints |
| `startOfDay()` | Start of today |
| `startOfWeek()` | Start of this week |
| `startOfMonth()` | Start of this month |
| `startOfYear()` | Start of this year |
| `endOfDay()` | End of today |
| `endOfWeek()` | End of this week |
| `endOfMonth()` | End of this month |

## Relative Dates

| Expression | Meaning |
|------------|---------|
| `-1d` | 1 day ago |
| `-7d` | 7 days ago |
| `-2w` | 2 weeks ago |
| `-1m` | 1 month ago |
| `"-4h"` | 4 hours ago |

## Examples

```jql
# All open bugs assigned to me, ordered by priority
project = PROJ AND type = Bug AND assignee = currentUser() AND status != Done ORDER BY priority DESC

# Issues updated in the last 3 days
updated >= -3d ORDER BY updated DESC

# Unresolved issues in current sprint
sprint in openSprints() AND resolution is EMPTY ORDER BY rank ASC

# Issues with a specific label, excluding subtasks
labels = "backend" AND type != Sub-task ORDER BY created DESC
```
