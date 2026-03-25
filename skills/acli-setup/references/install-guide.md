# ACLI Installation Guide

## macOS

### Homebrew (recommended)

```bash
brew tap atlassian/tap
brew install acli
```

### npm

```bash
npm install -g @atlassian/acli
```

## Linux

### npm (recommended)

```bash
npm install -g @atlassian/acli
```

### Binary download

Download the latest release from the [ACLI downloads page](https://developer.atlassian.com/cloud/acli/guides/download-supported-packages/).

```bash
# Example for Linux x64
curl -fsSL https://developer.atlassian.com/cloud/acli/guides/download-supported-packages/ -o acli
chmod +x acli
sudo mv acli /usr/local/bin/
```

## Windows

### npm (recommended)

```bash
npm install -g @atlassian/acli
```

### Chocolatey

```powershell
choco install acli
```

### Binary download

Download from the [ACLI downloads page](https://developer.atlassian.com/cloud/acli/guides/download-supported-packages/) and add to PATH.

## Verify Installation

```bash
acli --version
```

## Platform Detection

To detect the platform programmatically in bash:

```bash
OS=$(uname -s)
case "$OS" in
  Darwin)  echo "macOS detected" ;;
  Linux)   echo "Linux detected" ;;
  MINGW*|MSYS*|CYGWIN*) echo "Windows (Git Bash) detected" ;;
  *)       echo "Unknown OS: $OS" ;;
esac
```

## Troubleshooting

- **`acli: command not found`**: Ensure the install location is in your `$PATH`
- **npm permission errors on macOS/Linux**: Use `sudo npm install -g` or configure npm prefix
- **Windows PATH**: After npm install, restart your terminal so the PATH updates take effect
- **Proxy issues**: Set `HTTP_PROXY` and `HTTPS_PROXY` environment variables if behind a corporate proxy

## References

- [Official install guide](https://developer.atlassian.com/cloud/acli/guides/install-acli/)
- [macOS install](https://developer.atlassian.com/cloud/acli/guides/install-macos/)
- [Linux install](https://developer.atlassian.com/cloud/acli/guides/install-linux/)
- [Windows install](https://developer.atlassian.com/cloud/acli/guides/install-windows/)
