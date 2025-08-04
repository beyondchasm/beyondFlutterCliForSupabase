#!/bin/bash

# Beyond Flutter CLI - Alias Installation Script
# This script creates a shell alias for easier CLI usage

CLI_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ALIAS_NAME="beyond"
COMMAND="dart run $CLI_PATH/bin/beyond_flutter_cli.dart"

echo "🚀 Installing Beyond Flutter CLI alias..."
echo "📁 CLI Path: $CLI_PATH"

# Detect shell
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_RC="$HOME/.zshrc"
    SHELL_NAME="zsh"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_RC="$HOME/.bashrc"
    SHELL_NAME="bash"
else
    echo "⚠️  Unsupported shell. Please add the alias manually:"
    echo "   alias $ALIAS_NAME='$COMMAND'"
    exit 1
fi

echo "🔧 Detected shell: $SHELL_NAME"
echo "📝 Adding alias to: $SHELL_RC"

# Check if alias already exists
if grep -q "alias $ALIAS_NAME=" "$SHELL_RC" 2>/dev/null; then
    echo "⚠️  Alias '$ALIAS_NAME' already exists in $SHELL_RC"
    echo "🔄 Updating existing alias..."
    # Remove old alias
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "/alias $ALIAS_NAME=/d" "$SHELL_RC"
    else
        # Linux
        sed -i "/alias $ALIAS_NAME=/d" "$SHELL_RC"
    fi
fi

# Add new alias
echo "" >> "$SHELL_RC"
echo "# Beyond Flutter CLI" >> "$SHELL_RC"
echo "alias $ALIAS_NAME='$COMMAND'" >> "$SHELL_RC"

echo "✅ Alias installed successfully!"
echo ""
echo "📋 Usage examples:"
echo "   $ALIAS_NAME scaffold --backend firebase"
echo "   $ALIAS_NAME scaffold --backend supabase --with-auth --with-user"
echo "   $ALIAS_NAME feature user_profile --backend rest-api"
echo "   $ALIAS_NAME init"
echo "   $ALIAS_NAME --version"
echo ""
echo "🔄 To use the alias immediately:"
echo "   source $SHELL_RC"
echo ""
echo "Or restart your terminal."