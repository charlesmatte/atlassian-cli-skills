---
name: confluence-page
description: "Create, view, update, and delete Confluence pages. View pages via ACLI, create/update/delete via Confluence REST API. WHEN: confluence page, create page, edit page, update page, delete page, view page, wiki page, confluence content, page children, child pages, confluence write, publish page, new page, page crud."
license: MIT
metadata:
  author: cmatte
  version: "0.2.0"
---

# Confluence Pages

View, create, update, and delete Confluence pages. Uses ACLI for viewing and the Confluence REST API v2 for write operations.

## When to Use This Skill

- User wants to view a Confluence page
- User wants to create a new page in a space
- User wants to update/edit an existing page
- User wants to delete a page
- User wants to list child pages under a parent

## Prerequisites

- ACLI installed and authenticated (see **acli-setup**)
- Active profile set (see **acli-profile**) so `$ACLI_SITE` and `$ACLI_EMAIL` are available
- **For create/update/delete**: `$ACLI_TOKEN` must be set in the profile (the same API token used for `acli auth login`)

If `$ACLI_TOKEN` is not set when a write operation is needed, guide the user:
> Your profile needs an API token for Confluence write operations. Update your profile with `/acli-profile` and include your API token.

## Commands

### View Page (ACLI)

```bash
acli confluence page view --site "$ACLI_SITE" --id "PAGE_ID"
```

With body content:

```bash
acli confluence page view --site "$ACLI_SITE" --id "PAGE_ID" \
  --body-format view
```

Specific version:

```bash
acli confluence page view --site "$ACLI_SITE" --id "PAGE_ID" \
  --version 3
```

JSON output (useful for extracting version number before updates):

```bash
acli confluence page view --site "$ACLI_SITE" --id "PAGE_ID" --json
```

### Create Page (REST API)

**Step 1**: Get the numeric space ID (required by the API):

```bash
acli confluence space view --site "$ACLI_SITE" --key "SPACE_KEY" --json
```

**Step 2**: Create the page:

```bash
curl -s -X POST \
  "https://$ACLI_SITE/wiki/api/v2/pages" \
  -H "Authorization: Basic $(echo -n "$ACLI_EMAIL:$ACLI_TOKEN" | base64)" \
  -H "Content-Type: application/json" \
  -d '{
    "spaceId": "SPACE_ID",
    "status": "current",
    "title": "Page Title",
    "body": {
      "representation": "storage",
      "value": "<p>Page content here</p>"
    }
  }'
```

Create under a parent page:

```bash
curl -s -X POST \
  "https://$ACLI_SITE/wiki/api/v2/pages" \
  -H "Authorization: Basic $(echo -n "$ACLI_EMAIL:$ACLI_TOKEN" | base64)" \
  -H "Content-Type: application/json" \
  -d '{
    "spaceId": "SPACE_ID",
    "parentId": "PARENT_PAGE_ID",
    "status": "current",
    "title": "Child Page Title",
    "body": {
      "representation": "storage",
      "value": "<p>Child page content</p>"
    }
  }'
```

Create as draft:

```bash
curl -s -X POST \
  "https://$ACLI_SITE/wiki/api/v2/pages" \
  -H "Authorization: Basic $(echo -n "$ACLI_EMAIL:$ACLI_TOKEN" | base64)" \
  -H "Content-Type: application/json" \
  -d '{
    "spaceId": "SPACE_ID",
    "status": "draft",
    "title": "Draft Page",
    "body": {
      "representation": "storage",
      "value": "<p>Work in progress</p>"
    }
  }'
```

### Update Page (REST API)

**Important**: Always fetch the current page first to get the version number.

**Step 1**: Get current version:

```bash
acli confluence page view --site "$ACLI_SITE" --id "PAGE_ID" --json
```

**Step 2**: Update with incremented version number:

```bash
curl -s -X PUT \
  "https://$ACLI_SITE/wiki/api/v2/pages/PAGE_ID" \
  -H "Authorization: Basic $(echo -n "$ACLI_EMAIL:$ACLI_TOKEN" | base64)" \
  -H "Content-Type: application/json" \
  -d '{
    "id": "PAGE_ID",
    "status": "current",
    "title": "Updated Page Title",
    "body": {
      "representation": "storage",
      "value": "<p>Updated content</p>"
    },
    "version": {
      "number": CURRENT_VERSION_PLUS_ONE,
      "message": "Updated via ACLI skill"
    }
  }'
```

### Delete Page (REST API)

```bash
curl -s -X DELETE \
  "https://$ACLI_SITE/wiki/api/v2/pages/PAGE_ID" \
  -H "Authorization: Basic $(echo -n "$ACLI_EMAIL:$ACLI_TOKEN" | base64)"
```

### List Child Pages (REST API)

```bash
curl -s -X GET \
  "https://$ACLI_SITE/wiki/api/v2/pages/PAGE_ID/children?limit=25" \
  -H "Authorization: Basic $(echo -n "$ACLI_EMAIL:$ACLI_TOKEN" | base64)"
```

## Confluence Storage Format

Page content uses Confluence storage format (XHTML-based). Common elements:

| Element | Syntax |
|---------|--------|
| Paragraph | `<p>text</p>` |
| Headings | `<h1>` through `<h6>` |
| Bold | `<strong>text</strong>` |
| Italic | `<em>text</em>` |
| Bullet list | `<ul><li>item</li></ul>` |
| Numbered list | `<ol><li>item</li></ol>` |
| Link | `<a href="url">text</a>` |
| Table | `<table><tr><th>Header</th></tr><tr><td>Cell</td></tr></table>` |
| Code block | `<ac:structured-macro ac:name="code"><ac:plain-text-body><![CDATA[code here]]></ac:plain-text-body></ac:structured-macro>` |
| Info panel | `<ac:structured-macro ac:name="info"><ac:rich-text-body><p>Info text</p></ac:rich-text-body></ac:structured-macro>` |

See [storage-format.md](references/storage-format.md) for the full reference.

## Rules

1. **Always use `$ACLI_SITE`** -- never hardcode site URLs
2. **Confirm before delete** -- always ask the user before deleting a page
3. **Always fetch before update** -- get the current version number to avoid 409 version conflicts
4. **Token check** -- if `$ACLI_TOKEN` is empty or unset, do not attempt REST API calls; guide the user to update their profile
5. The REST API requires numeric `spaceId`, not the space key -- always resolve the key to an ID via `space view --key KEY --json` first
6. Use `base64` encoding for the auth header -- this works in bash on all platforms (macOS, Linux, Windows Git Bash)
7. Prefer ACLI commands when available (view)

## Cross-References

- **confluence-space** to find space keys and IDs
- **confluence-search** to find pages by content or title
- **acli-profile** if `$ACLI_SITE` or `$ACLI_TOKEN` is not set
- **acli-setup** if ACLI is not installed
