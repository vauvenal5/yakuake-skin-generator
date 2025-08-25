# yakuake-skin-generator
Generates skin based on Breez (by Andreas Kainz) with correct accent color.

All this script does is create a copy of the Breeze skin and replace the accent color with the one found in the global KDE settings.

It then copies the new skin to .local and restarts Yakuake to apply the new skin.

You can switch between light and dark mode by changing the first parameter in the script.

## SSH Config Generator
This repository also includes a utility to generate SSH config files for GitHub with custom settings.

### Usage
```bash
./generate-ssh-config.sh [OPTIONS]
```

### Examples
```bash
# Generate basic SSH config for GitHub
./generate-ssh-config.sh

# Generate config for GitHub Enterprise server
./generate-ssh-config.sh --hostname github.company.com --output github.config

# Generate config with custom SSH key and append to ~/.ssh/config
./generate-ssh-config.sh --identity ~/.ssh/github_key --append

# Generate config for GitHub through a custom port
./generate-ssh-config.sh --hostname github.example.com --port 2222
```

### Options
- `--host`: SSH host alias (default: github.com)
- `--hostname`: Actual hostname to connect to (default: github.com)
- `--user`: SSH user (default: git)
- `--port`: SSH port (default: 22)
- `--identity`: SSH identity file (default: ~/.ssh/id_rsa)
- `--output`: Output file (default: stdout)
- `--append`: Append to SSH config file (~/.ssh/config)

## Background
I was always annoyed that Yakuake doesn't follow the global accent color set in KDE System Settings.
