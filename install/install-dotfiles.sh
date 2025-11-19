
#!/bin/bash
set -e

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/danielucho345/.dotfiles3"
REPO_NAME=".dotfiles3"

# Ensure stow is installed
if ! command -v stow >/dev/null 2>&1; then
  echo "Stow is not installed. Run install-stow.sh first."
  exit 1
fi

# Move to home directory
cd ~ || exit

# Clone or update repo
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' exists. Pulling latest changes..."
  cd "$REPO_NAME" && git pull --recurse-submodules
else
  git clone --recurse-submodules "$REPO_URL" "$REPO_NAME"
  cd "$REPO_NAME"
fi

# Navigate to .config inside repo
CONFIG_DIR="$REPO_NAME/.config"
if [ ! -d "$CONFIG_DIR" ]; then
  echo ".config directory not found in repo!"
  exit 1
fi

# Remove only the configs that exist in your dotfiles repo
echo "Cleaning old configs managed by dotfiles..."
for folder in "$CONFIG_DIR"*/; do
  folder_name=$(basename "$folder")
  target="$HOME/.config/$folder_name"
  if [ -e "$target" ]; then
    echo "Removing old config: $target"
    rm -rf "$target"
  fi
done

# Stow all folders inside .config
echo "Stowing .config folders..."
cd "$CONFIG_DIR" || exit
for folder in */ ; do
  [ -d "$folder" ] || continue
  echo "Stowing $folder..."
  stow -v "$folder" -t "$HOME/.config"
done

echo "All .config folders from dotfiles stowed successfully!"
cd "$ORIGINAL_DIR"

