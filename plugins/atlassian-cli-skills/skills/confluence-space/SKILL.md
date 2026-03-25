---
name: confluence-space
description: "Manage Confluence spaces using ACLI. List, view, create, update, archive, and restore spaces. WHEN: confluence space, list spaces, create space, view space, update space, archive space, restore space, space management, wiki space, confluence wiki, confluence spaces."
license: MIT
metadata:
  author: cmatte
  version: "0.2.0"
---

# Confluence Spaces

List, view, create, update, archive, and restore Confluence spaces via the Atlassian CLI.

## When to Use This Skill

- User wants to list available Confluence spaces
- User wants to create a new space
- User wants to view space details (description, permissions, homepage)
- User wants to update a space name, description, or status
- User wants to archive or restore a space

## Prerequisites

- ACLI installed and authenticated (see **acli-setup**)
- Active profile set (see **acli-profile**) so `$ACLI_SITE` is available

If `$ACLI_SITE` is not set, prompt the user to run `/acli-profile` first.

## Commands

### List Spaces

```bash
acli confluence space list --site "$ACLI_SITE"
```

Filter by type:

```bash
acli confluence space list --site "$ACLI_SITE" --type global
```

Filter by status:

```bash
acli confluence space list --site "$ACLI_SITE" --status current
```

JSON output for programmatic use:

```bash
acli confluence space list --site "$ACLI_SITE" --json
```

### View Space

By key:

```bash
acli confluence space view --site "$ACLI_SITE" --key "SPACE_KEY"
```

By ID:

```bash
acli confluence space view --site "$ACLI_SITE" --id "SPACE_ID"
```

With JSON output (useful for extracting `id` for page creation):

```bash
acli confluence space view --site "$ACLI_SITE" --key "SPACE_KEY" --json
```

### Create Space

```bash
acli confluence space create --site "$ACLI_SITE" \
  --key "KEY" \
  --name "Space Name"
```

With description:

```bash
acli confluence space create --site "$ACLI_SITE" \
  --key "DEV" \
  --name "Development" \
  --description "Engineering documentation and guides"
```

Private space:

```bash
acli confluence space create --site "$ACLI_SITE" \
  --key "PRIV" \
  --name "Private Space" \
  --private
```

### Update Space

```bash
acli confluence space update --site "$ACLI_SITE" --key "SPACE_KEY" \
  --name "New Space Name"
```

Update description:

```bash
acli confluence space update --site "$ACLI_SITE" --key "SPACE_KEY" \
  --description "Updated description"
```

### Archive Space

```bash
acli confluence space archive --site "$ACLI_SITE" --key "SPACE_KEY"
```

### Restore Space

```bash
acli confluence space restore --site "$ACLI_SITE" --key "SPACE_KEY"
```

## Rules

1. **Always use `$ACLI_SITE`** -- never hardcode site URLs in commands
2. **Confirm before archive** -- always ask the user before archiving a space (destructive)
3. **Space keys are uppercase** by convention (e.g., `DEV`, `HR`, `PROJ`)
4. Use `--json` when chaining with other operations (e.g., extracting `id` for page creation)
5. Type values: `global` (team spaces) or `personal` (user spaces)
6. Status values: `current` (active) or `archived`

## Cross-References

- **confluence-page** to manage pages within a space
- **confluence-search** to search content across spaces
- **acli-profile** if `$ACLI_SITE` is not set
- **acli-setup** if ACLI is not installed
