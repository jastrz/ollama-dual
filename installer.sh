#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="ollama-dual"
TARGET_LINK="$HOME/bin/$SCRIPT_NAME"

echo "Installing $SCRIPT_NAME to run from anywhere..."

# Check if script exists
if [ ! -f "$SCRIPT_DIR/ollama-dual.sh" ]; then
  echo "Error: ollama-dual.sh not found in $SCRIPT_DIR"
  exit 1
fi

# Make the script executable
chmod +x "$SCRIPT_DIR/ollama-dual.sh"
echo "✓ Made ollama-dual.sh executable"

# Create ~/bin if it doesn't exist
if [ ! -d "$HOME/bin" ]; then
  mkdir -p "$HOME/bin"
  echo "✓ Created ~/bin directory"
fi

# Add ~/bin to PATH in .bashrc if not already there
if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
  echo "✓ Added ~/bin to PATH in ~/.bashrc"
  echo "! Run 'source ~/.bashrc' or restart your terminal"
fi

# Create symlink
if [ -L "$TARGET_LINK" ]; then
  rm "$TARGET_LINK"
  echo "! Removed existing symlink"
fi

ln -s "$SCRIPT_DIR/ollama-dual.sh" "$TARGET_LINK"
echo "✓ Created symlink at $TARGET_LINK"

echo ""
echo "Installation complete!"
echo "Run '$SCRIPT_NAME start' from anywhere to start both Ollama instances."
