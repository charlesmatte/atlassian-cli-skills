---
name: acli-setup
description: "Install and configure the Atlassian CLI (ACLI) for first use. Guides through installation, authentication, and initial profile creation. WHEN: install acli, setup atlassian, configure jira cli, atlassian login, first time setup, acli auth, connect to jira, connect to atlassian, acli install, get started atlassian."
license: MIT
metadata:
  author: cmatte
  version: "0.1.0"
---

# ACLI Setup

Guides first-time installation and authentication for the Atlassian CLI.

## When to Use This Skill

- User needs to install ACLI for the first time
- User needs to authenticate with an Atlassian site
- User wants to verify their ACLI installation
- User mentions "setup", "install", or "configure" with Atlassian/Jira/ACLI
- Another skill detects that `acli` is not available

## Steps

### 1. Check Installation

```bash
acli --version
```

If the command is not found, proceed to step 2. If it succeeds, skip to step 3.

### 2. Install ACLI

Detect the platform and guide accordingly:

```bash
uname -s
```

See [install-guide.md](references/install-guide.md) for platform-specific instructions.

### 3. Authenticate

The user needs an API token from https://id.atlassian.com/manage-profile/security/api-tokens

Ask the user for:
- Their Atlassian site (e.g., `mycompany.atlassian.net`)
- Their email address
- Their API token

Then authenticate:

```bash
echo "TOKEN_HERE" | acli jira auth login --site "SITE.atlassian.net" --email "USER@EXAMPLE.COM" --token
```

For OAuth (SSO organizations):

```bash
acli jira auth login --web
```

### 4. Verify Authentication

```bash
acli jira auth status
```

### 5. Create First Profile

After successful authentication, invoke **acli-profile** to save the site as a named profile so it persists across sessions.

## Authentication Methods

| Method | Command | Best For |
|--------|---------|----------|
| API Token | `echo TOKEN \| acli jira auth login --site X --email Y --token` | Most users |
| OAuth | `acli jira auth login --web` | SSO organizations |
| API Key | `acli admin auth login --key K` | Admin API only |

## Rules

1. Never store or echo API tokens in plain text in SKILL.md or logs
2. Guide the user to paste their token securely via stdin pipe
3. After authentication, always create a profile via **acli-profile**
4. If the user has multiple sites, guide them to authenticate and create a profile for each

## Cross-References

- After setup completes, use **acli-profile** to save the authenticated site as a named profile
- Then use **jira-workitem**, **jira-search**, or **jira-sprint** for Jira operations
- For admin API authentication, see **admin-user**
