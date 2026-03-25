---
name: admin-user
description: "Manage Atlassian organization users via the Admin API. Activate, deactivate, and delete user accounts. WHEN: admin user, manage users, deactivate user, activate user, delete user, user management, atlassian admin, org admin, user list, disable user, remove user."
license: MIT
metadata:
  author: cmatte
  version: "0.1.0"
---

# Atlassian Admin - User Management

Manage organization users via the Atlassian Admin API.

## When to Use This Skill

- User wants to manage Atlassian organization members
- User asks to activate, deactivate, or remove users
- User mentions admin operations or user management

## Prerequisites

- ACLI installed (see **acli-setup**)
- Authenticated with admin API key: `acli admin auth login --key API_KEY`
- Note: Admin API uses **API keys**, not API tokens (different from Jira auth)

## Commands

### Check Admin Auth Status

```bash
acli admin auth status
```

### Authenticate (Admin API)

```bash
acli admin auth login --key "API_KEY_HERE"
```

### List Users

```bash
acli admin user list
```

### Activate User

```bash
acli admin user activate --email "user@example.com"
```

### Deactivate User

```bash
acli admin user deactivate --email "user@example.com"
```

### Delete User

```bash
acli admin user delete --email "user@example.com" --yes
```

### Cancel Pending Delete

```bash
acli admin user cancel-delete --email "user@example.com"
```

## Field Management

### Create Custom Field

```bash
acli admin field create --name "Field Name" --type "text"
```

### Delete Custom Field

```bash
acli admin field delete --id "FIELD_ID" --yes
```

## Rules

1. **DESTRUCTIVE OPERATIONS**: Deactivate and delete have significant impact -- always confirm with the user before executing
2. Admin API uses **API keys**, not API tokens -- different authentication from Jira
3. Admin commands operate at the **organization level**, not site level -- no `--site` flag needed
4. `cancel-delete` can reverse a pending deletion but not a completed one

## Cross-References

- **acli-setup** for admin API authentication
- **acli-profile** for switching to an admin-specific profile
- **jira-workitem** for issue-level operations (not admin)
