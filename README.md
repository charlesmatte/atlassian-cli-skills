# Atlassian CLI Plugin for Claude Code

A [Claude Code](https://claude.ai/code) skills plugin that integrates the [Atlassian CLI (ACLI)](https://developer.atlassian.com/cloud/acli/) with multi-profile support for managing Jira issues, sprints, and admin operations across multiple Atlassian sites.

## Features

- **Multi-profile management** — Switch between Atlassian sites/accounts within a single session
- **Jira work items** — Create, edit, transition, search, and manage issues
- **JQL search** — Query Jira with full JQL support and saved filters
- **Sprint management** — View boards, sprints, and backlog
- **Admin operations** — Manage organization users (activate, deactivate, delete)
- **Cross-platform** — Works on Windows, macOS, and Linux

## Prerequisites

- [Claude Code](https://claude.ai/code) v1.0.33 or later (CLI, desktop app, or IDE extension)
- [Node.js](https://nodejs.org/) 18+ (required to install ACLI)
- An Atlassian Cloud account

## Installation

### Step 1: Add the marketplace

From within Claude Code, run:

```
/plugin marketplace add charlesmatte/atlassian-cli-skills
```

### Step 2: Install the plugin

```
/plugin install atlassian@atlassian-cli-skills
```

Choose your preferred scope when prompted:
- **User** — available in all your projects (recommended)
- **Project** — shared with collaborators via `.claude/settings.json`
- **Local** — local only, gitignored

### Step 3: Reload

If you're in an active session, reload the plugin:

```
/reload-plugins
```

### Alternative: Install from a local clone

```bash
git clone https://github.com/charlesmatte/atlassian-cli-skills.git
```

Then in Claude Code:

```
/plugin marketplace add ./atlassian-cli-skills
/plugin install atlassian@atlassian-cli-skills
```

## Getting Started

### 1. Install ACLI

If you don't have the Atlassian CLI installed yet, use the setup skill:

```
/acli-setup
```

Or install it manually:

```bash
# macOS
brew tap atlassian/tap && brew install acli

# Any platform with Node.js
npm install -g @atlassian/acli
```

Verify the installation:

```bash
acli --version
```

### 2. Authenticate with your Atlassian site

ACLI supports three authentication methods depending on your use case. Most users should start with **API Token** authentication.

---

#### Option A: API Token (recommended for most users)

API tokens let you authenticate as yourself for Jira, Confluence, and other Atlassian products.

**Step 1 — Create an API token in the Atlassian portal:**

1. Log in to [id.atlassian.com](https://id.atlassian.com)
2. Navigate to **Security** > **API tokens**, or go directly to:\
   [https://id.atlassian.com/manage-profile/security/api-tokens](https://id.atlassian.com/manage-profile/security/api-tokens)
3. Click **Create API token**
4. Enter a label (e.g., `Claude Code ACLI`)
5. Set an expiration period (1–365 days; defaults to 1 year)
6. Click **Create**
7. **Copy the token immediately** — you cannot retrieve it after closing the dialog
8. Store it in a password manager (do not commit it to source control)

> **Scoped tokens (optional, more secure):** Click **Create API token with scopes** instead to restrict the token to specific products (Jira or Confluence) and actions (view, write, delete). This is recommended for production use.

**Step 2 — Find your Atlassian site name:**

Your site name is the subdomain of your Atlassian Cloud URL. For example:
- URL: `https://mycompany.atlassian.net` → site name: `mycompany.atlassian.net`
- URL: `https://acme-corp.atlassian.net` → site name: `acme-corp.atlassian.net`

You can find this by logging into [Jira](https://www.atlassian.com/software/jira) and checking the URL in your browser's address bar.

**Step 3 — Authenticate ACLI:**

```bash
echo "YOUR_TOKEN" | acli jira auth login \
  --site "yoursite.atlassian.net" \
  --email "you@example.com" \
  --token
```

Or read the token from a file:

```bash
acli jira auth login \
  --site "yoursite.atlassian.net" \
  --email "you@example.com" \
  --token < ~/path/to/token.txt
```

**Step 4 — Verify:**

```bash
acli jira auth status
```

You should see your site and authenticated user displayed.

---

#### Option B: OAuth (for SSO organizations)

If your organization uses SSO (Single Sign-On) and you cannot use API tokens, use the browser-based OAuth flow:

1. Run:
   ```bash
   acli jira auth login --web
   ```
2. Your browser opens automatically to the Atlassian authorization page
3. Select your Atlassian site from the list
4. Click **Accept** to authorize ACLI
5. You'll see a confirmation in the browser — close the tab
6. Return to your terminal; authentication is complete

Verify with:

```bash
acli jira auth status
```

---

#### Option C: Admin API Key (for organization administration only)

Admin API keys are separate from user API tokens. They provide organization-level access for managing users, groups, and settings. You only need this if you plan to use the `admin-user` skill.

**Step 1 — Create an Admin API key in the Atlassian admin portal:**

1. Go to [admin.atlassian.com](https://admin.atlassian.com) and select your organization
2. Navigate to **Organization settings** > **API keys**
3. Choose one of:
   - **API keys with scopes** (recommended) — restricts the key to specific admin operations
   - **API keys without scopes** — unrestricted access to all Admin APIs
4. Click **Create API key**
5. Enter a descriptive name (e.g., `Claude Code Admin`)
6. Set an expiration date (max 1 year)
7. If using scoped keys, select the API scopes your key needs
8. Click **Create**
9. **Copy the key immediately** — you cannot retrieve it later

> You must be an **Organization admin** to create Admin API keys.

**Step 2 — Authenticate ACLI with the admin key:**

```bash
acli admin auth login --api-key
```

You'll be prompted to enter your API key.

---

### 3. Create your first profile

After authenticating, save your site as a named profile so the plugin remembers it across sessions:

```
/acli-profile create work yoursite.atlassian.net you@example.com
```

If you have multiple Atlassian sites, repeat for each:

```
/acli-profile create client-a clienta.atlassian.net me@consulting.com
```

### 4. Start using Jira

You're ready! Try asking Claude things like:

- "Search for my open bugs in PROJECT"
- "Create a task in PROJECT: Fix the login timeout"
- "What's in the current sprint?"
- "Transition PROJ-123 to In Progress"

## Skills Reference

### `/acli-setup` — Installation & Authentication

Guides you through installing ACLI and authenticating with your Atlassian site. Detects your OS and recommends the right install method.

### `/acli-profile` — Profile Management

Manage multiple Atlassian site profiles for switching between accounts within a session.

| Command | Description |
|---------|-------------|
| `/acli-profile show` | Show the active profile |
| `/acli-profile list` | List all configured profiles |
| `/acli-profile create <name> <site> <email>` | Add a new profile |
| `/acli-profile switch <name>` | Switch to a different profile |
| `/acli-profile delete <name>` | Remove a profile |

Profiles are stored in `~/.config/acli-claude/profiles.json`. The active profile's site and email are automatically injected into every ACLI command via environment variables (`$ACLI_SITE`, `$ACLI_EMAIL`).

### `/jira-workitem` — Issue Management

Create, view, edit, transition, and delete Jira issues. Supports comments, attachments, and bulk operations.

Examples:
- "Create a bug in PROJ: Login page returns 500"
- "Assign PROJ-42 to alice@example.com"
- "Close PROJ-42 with status Done"
- "Add a comment to PROJ-42: Fixed in latest deploy"

### `/jira-search` — JQL Search

Search Jira with JQL queries. Claude translates natural language to JQL automatically.

Examples:
- "Find all open bugs assigned to me"
- "Show issues updated in the last 3 days"
- "List unassigned tasks in PROJECT"
- "Search for issues with label 'backend'"

### `/jira-sprint` — Sprint & Board Management

View boards, active sprints, sprint progress, and backlog.

Examples:
- "What boards exist for PROJECT?"
- "Show me the active sprint"
- "What's still in progress in the current sprint?"
- "List the sprint backlog"

### `/admin-user` — Organization User Management

Manage Atlassian organization users. Requires admin API key authentication (separate from Jira API tokens).

Examples:
- "List all organization users"
- "Deactivate user@example.com"
- "Reactivate user@example.com"

## Multi-Profile Workflow

If you work with multiple Atlassian sites (e.g., your company + a client), set up a profile for each:

```
/acli-profile create work mycompany.atlassian.net me@company.com
/acli-profile create client-a clienta.atlassian.net me@consulting.com
```

Then switch between them mid-session:

```
/acli-profile switch client-a
```

All subsequent ACLI commands will target the new site. Switch back anytime:

```
/acli-profile switch work
```

The active profile persists across sessions — the plugin reloads it automatically on startup via a SessionStart hook.

## Troubleshooting

### "acli: command not found"

ACLI is not installed or not in your PATH. Run `/acli-setup` or install manually with `npm install -g @atlassian/acli`.

### "$ACLI_SITE is not set"

No active profile is configured. Run `/acli-profile` to create one.

### "Authentication failed" or "401 Unauthorized"

Your API token may have expired (tokens expire after the period you set, max 1 year). To fix:

1. Go to [id.atlassian.com/manage-profile/security/api-tokens](https://id.atlassian.com/manage-profile/security/api-tokens)
2. Revoke the old token
3. Create a new one
4. Re-authenticate:

```bash
echo "NEW_TOKEN" | acli jira auth login --site "$ACLI_SITE" --email "$ACLI_EMAIL" --token
```

### "Forbidden" or "403" errors

Your API token may lack the required scopes. If you created a scoped token, ensure it has **write** permissions for the operations you're performing (e.g., creating issues requires write access to Jira).

### Admin commands fail with "Unauthorized"

Admin API keys are separate from Jira API tokens. You need an Admin API key created at [admin.atlassian.com](https://admin.atlassian.com) > **Organization settings** > **API keys**. See [Option C in Getting Started](#option-c-admin-api-key-for-organization-administration-only).

### Plugin not loading after install

Run `/reload-plugins` in Claude Code to reload all plugins.

### Python not found (profile operations)

Profile management uses Python for JSON manipulation. Ensure `python3` (macOS/Linux) or `python` (Windows) is available in your PATH.

## Uninstall

```
/plugin uninstall atlassian@atlassian-cli-skills
```

To also remove your saved profiles:

```bash
rm -rf ~/.config/acli-claude
```

## License

MIT
