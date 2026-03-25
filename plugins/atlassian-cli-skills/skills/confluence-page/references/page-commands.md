# Confluence Page Commands Reference

## ACLI Commands

### `page view`

```
acli confluence page view --site "$ACLI_SITE" --id "PAGE_ID" [flags]
```

| Flag | Type | Description |
|------|------|-------------|
| `--id` | string | Page ID (numeric, required) |
| `--body-format` | string | Body format: `storage`, `atlas_doc_format`, or `view` |
| `--status` | string | Page status: `current`, `draft`, or `archived` |
| `--version` | int | Specific version number to retrieve |
| `--get-draft` | flag | Retrieve the draft version |
| `--include-collaborators` | flag | Include page collaborators |
| `--include-direct-children` | flag | Include direct child pages |
| `--include-labels` | flag | Include page labels |
| `--include-likes` | flag | Include like count |
| `--include-operations` | flag | Include permitted operations |
| `--include-properties` | flag | Include page properties |
| `--include-versions` | flag | Include version history |
| `--json` | flag | Output in JSON format |

## REST API Endpoints (v2)

Base URL: `https://$ACLI_SITE/wiki/api/v2`

Auth header: `Authorization: Basic $(echo -n "$ACLI_EMAIL:$ACLI_TOKEN" | base64)`

### Create Page

```
POST /pages
```

**Request body:**

```json
{
  "spaceId": "123456",
  "parentId": "789012",
  "status": "current",
  "title": "Page Title",
  "body": {
    "representation": "storage",
    "value": "<p>HTML content in storage format</p>"
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `spaceId` | string | Yes | Numeric space ID (not key) |
| `parentId` | string | No | Parent page ID for hierarchy |
| `status` | string | Yes | `current` (published) or `draft` |
| `title` | string | Yes | Page title |
| `body.representation` | string | Yes | Always `storage` |
| `body.value` | string | Yes | Content in Confluence storage format |

### Update Page

```
PUT /pages/{id}
```

**Request body:**

```json
{
  "id": "PAGE_ID",
  "status": "current",
  "title": "Updated Title",
  "body": {
    "representation": "storage",
    "value": "<p>Updated content</p>"
  },
  "version": {
    "number": 2,
    "message": "Description of changes"
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Page ID (must match URL) |
| `status` | string | Yes | `current` or `draft` |
| `title` | string | Yes | Page title (can be unchanged) |
| `body` | object | Yes | Updated content |
| `version.number` | int | Yes | Must be current version + 1 |
| `version.message` | string | No | Change description |

### Delete Page

```
DELETE /pages/{id}
```

No request body required. Returns 204 on success.

### List Child Pages

```
GET /pages/{id}/children?limit=25
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `limit` | int | Max results per page (default 25, max 250) |
| `cursor` | string | Pagination cursor from previous response |
| `sort` | string | Sort order: `id`, `-id`, `created-date`, `-created-date` |

## Common Error Codes

| Code | Meaning | Resolution |
|------|---------|------------|
| 401 | Unauthorized | Check `$ACLI_TOKEN` is valid and not expired |
| 403 | Forbidden | User lacks permission for this space/page |
| 404 | Not Found | Page or space ID doesn't exist |
| 409 | Version Conflict | Version number is wrong; re-fetch and retry |
| 400 | Bad Request | Invalid JSON body or missing required fields |
