# CQL (Confluence Query Language) Reference

## Syntax

```
field operator value [AND|OR field operator value ...] [ORDER BY field [ASC|DESC]]
```

Parentheses can be used for grouping: `(type = page AND space = "DEV") OR label = "important"`

## Fields

| Field | Description | Example |
|-------|-------------|---------|
| `type` | Content type | `type = page` |
| `space` | Space key | `space = "DEV"` |
| `title` | Content title | `title ~ "guide"` |
| `text` | Full text content (title + body) | `text ~ "deployment"` |
| `label` | Content labels | `label = "documentation"` |
| `creator` | Content creator | `creator = currentUser()` |
| `contributor` | Anyone who edited | `contributor = "user@example.com"` |
| `ancestor` | Parent/grandparent page ID | `ancestor = 12345` |
| `parent` | Direct parent page ID | `parent = 12345` |
| `content` | Content ID | `content = 12345` |
| `id` | Content ID | `id = 12345` |
| `created` | Creation date | `created >= "2025-01-01"` |
| `lastmodified` | Last modification date | `lastmodified >= now("-7d")` |

## Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `=` | Exact match | `title = "Release Notes"` |
| `!=` | Not equal | `space != "ARCHIVE"` |
| `~` | Contains (fuzzy) | `title ~ "deploy"` |
| `!~` | Does not contain | `text !~ "deprecated"` |
| `>` | Greater than | `created > "2025-01-01"` |
| `<` | Less than | `lastmodified < "2025-06-01"` |
| `>=` | Greater than or equal | `created >= now("-30d")` |
| `<=` | Less than or equal | `lastmodified <= now("-1d")` |
| `in` | In a list | `space in ("DEV", "OPS", "QA")` |
| `not in` | Not in a list | `label not in ("draft", "wip")` |
| `is` | Null check | `label is empty` |
| `is not` | Not null check | `label is not empty` |

## Functions

| Function | Description | Example |
|----------|-------------|---------|
| `currentUser()` | Logged-in user | `creator = currentUser()` |
| `now()` | Current date/time | `lastmodified >= now()` |
| `now("-7d")` | Relative date (days ago) | `created >= now("-7d")` |
| `now("-4w")` | Relative date (weeks ago) | `lastmodified >= now("-4w")` |
| `now("-3M")` | Relative date (months ago) | `created >= now("-3M")` |
| `startOfDay()` | Start of today | `created >= startOfDay()` |
| `startOfWeek()` | Start of this week | `created >= startOfWeek()` |
| `startOfMonth()` | Start of this month | `created >= startOfMonth()` |
| `startOfYear()` | Start of this year | `created >= startOfYear()` |
| `endOfDay()` | End of today | `created <= endOfDay()` |
| `endOfWeek()` | End of this week | `created <= endOfWeek()` |
| `endOfMonth()` | End of this month | `created <= endOfMonth()` |

## Content Types

| Type | Description |
|------|-------------|
| `page` | Wiki pages |
| `blogpost` | Blog posts |
| `attachment` | File attachments |
| `comment` | Page comments |

## Examples

### Basic Searches

Find all pages in a space:

```
type = page AND space = "DEV" ORDER BY title ASC
```

Find pages by title keyword:

```
type = page AND title ~ "architecture" ORDER BY lastmodified DESC
```

Full-text search across all content:

```
text ~ "API authentication" ORDER BY lastmodified DESC
```

### Filtered Searches

Pages created by current user in the last week:

```
type = page AND creator = currentUser() AND created >= now("-7d") ORDER BY created DESC
```

Pages with a specific label in a specific space:

```
type = page AND space = "DEV" AND label = "runbook" ORDER BY title ASC
```

Blog posts from the last month:

```
type = blogpost AND created >= now("-30d") ORDER BY created DESC
```

Recently modified pages (excluding archived spaces):

```
type = page AND lastmodified >= now("-3d") ORDER BY lastmodified DESC
```

### Advanced Searches

Pages under a parent (recursive):

```
type = page AND ancestor = 12345 ORDER BY title ASC
```

Content with multiple labels:

```
type = page AND label = "production" AND label = "runbook"
```

Pages in multiple spaces:

```
type = page AND space in ("DEV", "OPS", "INFRA") ORDER BY lastmodified DESC
```

Pages without a specific label:

```
type = page AND space = "DEV" AND label != "archived"
```

### Combining with OR

```
(type = page AND space = "DEV") OR (type = blogpost AND creator = currentUser())
```

## API Endpoint

```
GET https://{site}/wiki/rest/api/content/search?cql={cql}&limit={limit}&start={start}&expand={expand}
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `cql` | string | CQL query string (URL-encoded) |
| `limit` | int | Max results (default 25, max 200) |
| `start` | int | Offset for pagination (default 0) |
| `expand` | string | Comma-separated fields to expand (e.g., `version,space,body.view`) |

### Common Expand Values

| Value | Description |
|-------|-------------|
| `space` | Include space details |
| `version` | Include version number and author |
| `body.view` | Include rendered body content |
| `body.storage` | Include raw storage format body |
| `metadata.labels` | Include content labels |
| `ancestors` | Include parent page hierarchy |
