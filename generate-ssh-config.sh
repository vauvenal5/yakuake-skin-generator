#!/bin/bash

# SSH Config Generator for GitHub
# Generates SSH config entries to point github.com to a specific URL or configure custom GitHub access

# Default values
DEFAULT_HOST="github.com"
DEFAULT_HOSTNAME="github.com"
DEFAULT_USER="git"
DEFAULT_PORT="22"
DEFAULT_IDENTITY_FILE="~/.ssh/id_rsa"

# Function to display usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Generate SSH config entries for GitHub with custom settings"
    echo ""
    echo "OPTIONS:"
    echo "  -h, --host HOST           SSH host alias (default: github.com)"
    echo "  -n, --hostname HOSTNAME   Actual hostname to connect to (default: github.com)"
    echo "  -u, --user USER           SSH user (default: git)"
    echo "  -p, --port PORT           SSH port (default: 22)"
    echo "  -i, --identity FILE       SSH identity file (default: ~/.ssh/id_rsa)"
    echo "  -o, --output FILE         Output file (default: stdout)"
    echo "  -a, --append             Append to SSH config file (~/.ssh/config)"
    echo "  --help                   Show this help message"
    echo ""
    echo "EXAMPLES:"
    echo "  # Generate config for custom GitHub Enterprise server"
    echo "  $0 --hostname github.company.com --output github.config"
    echo ""
    echo "  # Generate config with custom SSH key"
    echo "  $0 --identity ~/.ssh/github_key --append"
    echo ""
    echo "  # Generate config for GitHub through a jump host"
    echo "  $0 --hostname proxy.company.com --port 2222"
}

# Initialize variables
HOST="$DEFAULT_HOST"
HOSTNAME="$DEFAULT_HOSTNAME"
USER="$DEFAULT_USER"
PORT="$DEFAULT_PORT"
IDENTITY_FILE="$DEFAULT_IDENTITY_FILE"
OUTPUT_FILE=""
APPEND_MODE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--host)
            HOST="$2"
            shift 2
            ;;
        -n|--hostname)
            HOSTNAME="$2"
            shift 2
            ;;
        -u|--user)
            USER="$2"
            shift 2
            ;;
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        -i|--identity)
            IDENTITY_FILE="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -a|--append)
            APPEND_MODE=true
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Function to generate SSH config entry
generate_ssh_config() {
    cat <<EOF
# SSH config for $HOST
Host $HOST
    HostName $HOSTNAME
    User $USER
    Port $PORT
    IdentityFile $IDENTITY_FILE
    IdentitiesOnly yes
    StrictHostKeyChecking yes

EOF
}

# Generate the config
CONFIG_CONTENT=$(generate_ssh_config)

# Output the configuration
if [ "$APPEND_MODE" = true ]; then
    # Append to ~/.ssh/config
    SSH_CONFIG_FILE="$HOME/.ssh/config"
    
    # Create .ssh directory if it doesn't exist
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    
    # Check if the host already exists in the config
    if [ -f "$SSH_CONFIG_FILE" ] && grep -q "^Host $HOST" "$SSH_CONFIG_FILE"; then
        echo "Warning: Host '$HOST' already exists in $SSH_CONFIG_FILE"
        echo "Please remove the existing entry or use a different host name."
        exit 1
    fi
    
    echo "$CONFIG_CONTENT" >> "$SSH_CONFIG_FILE"
    chmod 600 "$SSH_CONFIG_FILE"
    echo "SSH config appended to $SSH_CONFIG_FILE"
    
elif [ -n "$OUTPUT_FILE" ]; then
    # Output to specified file
    echo "$CONFIG_CONTENT" > "$OUTPUT_FILE"
    chmod 600 "$OUTPUT_FILE"
    echo "SSH config written to $OUTPUT_FILE"
    
else
    # Output to stdout
    echo "$CONFIG_CONTENT"
fi

# Display next steps
if [ "$APPEND_MODE" = true ] || [ -n "$OUTPUT_FILE" ]; then
    echo ""
    echo "Next steps:"
    echo "1. Ensure your SSH key exists: $IDENTITY_FILE"
    echo "2. Add your public key to your GitHub account"
    echo "3. Test the connection: ssh -T $HOST"
fi