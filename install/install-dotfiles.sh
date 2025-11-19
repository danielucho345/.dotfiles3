#!/bin/bash
set -e

# Save original working directory
ORIGINAL_DIR=$(pwd)

# Repo info
REPO_URL="https://github.com/danielucho345/.dotfiles3"
REPO_NAME=".dotfiles3"

# Ensure Stow is installed
if ! command -v stow >/dev/null 2>&1; then
  echo "Stow is not installed. Run install-stow.sh first."
  exit 1
fi

# Move to home directory for cloning/stowing
cd ~ || exit

# Clone repo if missing, otherwise pull latest
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' exists. Pulling latest changes..."
  cd "$REPO_NAME" && git pull
else
  git clone "$REPO_URL" "$REPO_NAME"
  cd "$REPO_NAME"
fi

# Remove old configs automatically (optional)
echo "Cleaning old configs..."
for dir in .config/* ~/.local/share/* ~/.cache/* ~/.??*; do
  # Only remove directories/files that exist in dotfiles
  base=$(basename "$dir")
  [ -e "$HOME/$dir" ] && rm -rf "$HOME/$dir"
done

# Automatically stow all directories in the repo
echo "Stowing directories..."
for dir in */ ; do
  [ -d "$dir" ] || continue
  echo "Stowing $dir..."
  stow -v "$dir"
done

echo "Dotfiles installation complete!"
cd "$ORIGINAL_DIR"

