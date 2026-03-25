# Loads the active ACLI profile into CLAUDE_ENV_FILE on session start.
# Cross-platform: PowerShell variant for Windows native environments.

$ErrorActionPreference = "SilentlyContinue"

$profilesDir = Join-Path $env:USERPROFILE ".config" "acli-claude"
$profilesFile = Join-Path $profilesDir "profiles.json"

# If no profiles file exists, nothing to load
if (-not (Test-Path $profilesFile)) {
    exit 0
}

try {
    $data = Get-Content $profilesFile -Raw | ConvertFrom-Json
    $active = $data.active

    if (-not $active -or -not $data.profiles.$active) {
        exit 0
    }

    $profile = $data.profiles.$active
    $site = $profile.site
    $email = $profile.email

    # Write bash-compatible export statements to CLAUDE_ENV_FILE
    # (Claude Code sources this as bash even on Windows)
    if ($env:CLAUDE_ENV_FILE) {
        $lines = @(
            "export ACLI_ACTIVE_PROFILE=`"$active`"",
            "export ACLI_SITE=`"$site`"",
            "export ACLI_EMAIL=`"$email`""
        )
        $lines | Out-File -FilePath $env:CLAUDE_ENV_FILE -Append -Encoding utf8
    }
}
catch {
    # Silently fail — profile loading is best-effort
}

exit 0
