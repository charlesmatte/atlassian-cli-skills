---
name: confluence-search
description: "Search Confluence content using CQL queries via the REST API. Find pages, blog posts, attachments, and spaces by title, content, label, author, or date. WHEN: search confluence, find page, confluence query, CQL, search wiki, find in confluence, confluence content, search space, find document, wiki search, confluence find."
license: MIT
metadata:
  author: cmatte
  version: "0.2.0"
---

# Confluence Search

Search Confluence content using CQL (Confluence Query Language) via the REST API.

## When to Use This Skill

- User wants to find pages, blog posts, or attachments in Confluence
- User asks to search across spaces or within a specific space
- User mentions CQL queries
- User wants to find content by title, body text, label, or author

## Prerequisites

- Active profile set (see **acli-profile**) so `$ACLI_SITE` and `$ACLI_EMAIL` are available
- `$ACLI_TOKEN` must be set in the profile (the same API token used for `acli auth login`)

If `$ACLI_TOKEN` is not set, guide the user:
> Your profile needs an API token for Confluence search. Update your profile with `/acli-profile` and include your API token.

## Commands

### Search with CQL

```bash
curl -s -G \
  "https://$ACLI_SITE/wiki/rest/api/content/search" \
  --data-urlencode "cql=type = page AND space = 'DEV' AND title ~ 'architecture'" \
  --data-urlencode "limit=25" \
  --data-urlencode "expand=version,space" \
  -H "Authorization: Basic $(echo -n "$ACLI_EMAIL:$ACLI_TOKEN" | base64)"
```

### Search with Pagination

```bash
curl -s -G \
  "https://$ACLI_SITE/wiki/rest/api/content/search" \
  --data-urlencode "cql=type = page AND space = 'DEV'" \
  --data-urlencode "limit=25" \
  --data-urlencode "start=25" \
  -H "Authorization: Basic $(echo -n "$ACLI_EMAIL:$ACLI_TOKEN" | base64)"
```

### Search with Body Content

```bash
curl -s -G \
  "https://$ACLI_SITE/wiki/rest/api/content/search" \
  --data-urlencode "cql=type = page AND text ~ 'deployment guide'" \
  --data-urlencode "limit=10" \
  --data-urlencode "expand=body.view,version,space" \
  -H "Authorization: Basic $(echo -n "$ACLI_EMAIL:$ACLI_TOKEN" | base64)"
```

## Common CQL Patterns

Translate natural language requests to CQL:

| User Says | CQL |
|-----------|-----|
| "find pages about X" | `type = page AND text ~ "X" ORDER BY lastmodified DESC` |
| "pages in SPACE" | `type = page AND space = "SPACE" ORDER BY title ASC` |
| "recently updated pages" | `type = page AND lastmodified >= now("-7d") ORDER BY lastmodified DESC` |
| "pages I created" | `type = page AND creator = currentUser() ORDER BY created DESC` |
| "blog posts this month" | `type = blogpost AND created >= now("-30d") ORDER BY created DESC` |
| "pages with label X" | `type = page AND label = "X" ORDER BY title ASC` |
| "pages under parent PAGE_ID" | `type = page AND ancestor = PAGE_ID ORDER BY title ASC` |
| "pages modified by USER" | `type = page AND contributor = "user@example.com" ORDER BY lastmodified DESC` |
| "attachments in SPACE" | `type = attachment AND space = "SPACE"` |
| "pages containing exact phrase" | `type = page AND text = "exact phrase"` |
| "pages updated today" | `type = page AND lastmodified >= now("-1d") ORDER BY lastmodified DESC` |
| "pages titled X" | `type = page AND title = "Exact Title"` |
| "pages with title containing X" | `type = page AND title ~ "partial"` |

See [cql-guide.md](references/cql-guide.md) for the full CQL syntax reference.

## Rules

1. **Always use `$ACLI_SITE` and `$ACLI_TOKEN`** from the active profile
2. **URL-encode CQL** -- always use `--data-urlencode` with curl, never put CQL directly in the URL
3. Default to `ORDER BY lastmodified DESC` if the user doesn't specify an order
4. Default `limit` to 25 results; increase for broader searches
5. For large result sets, use `limit` and `start` parameters for pagination
6. If `$ACLI_TOKEN` is not set, do not attempt API calls; guide user to `/acli-profile`
7. Use `expand=version,space` by default to include useful metadata in results
8. The `~` operator does fuzzy/contains matching; `=` does exact matching

## Cross-References

- **confluence-page** to view, create, or edit found pages
- **confluence-space** to explore available spaces
- **acli-profile** if `$ACLI_SITE` or `$ACLI_TOKEN` is not set
