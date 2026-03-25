# Changelog

## 0.2.0 (2026-03-25)

### Added
- Confluence space management with `confluence-space` skill (list, view, create, update, archive, restore)
- Confluence page CRUD with `confluence-page` skill (ACLI view + REST API create/update/delete)
- Confluence CQL search with `confluence-search` skill
- Confluence storage format reference documentation
- Optional `token` field in profile schema for REST API authentication
- `ACLI_TOKEN` environment variable export in session hooks

## 0.1.0 (2026-03-25)

### Added
- Multi-profile management with `acli-profile` skill
- Setup and onboarding with `acli-setup` skill
- Jira work item management with `jira-workitem` skill
- JQL search with `jira-search` skill
- Sprint and board management with `jira-sprint` skill
- Admin user management with `admin-user` skill
- Cross-platform hook scripts (bash + PowerShell)
- SessionStart hook for automatic profile loading
