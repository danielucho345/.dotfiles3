
#!/bin/bash
set -e

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/danielucho345/.dotfiles3"
REPO_NAME=".dotfiles"

# Ensure stow is installed
if ! command -v stow >/dev/null 2>&1; then
  echo "Stow is not installed. Run install-stow.sh first."
  exit 1
fi

cd ~

# Clone or update repo
if [ -d "$REPO_NAME/.git" ]; then
  echo "Updating existing dotfiles repo..."
  cd "$REPO_NAME"
  git pull --recurse-submodules
  git submodule update --init --recursive
else
  echo "Cloning dotfiles repo..."
  git clone --recurse-submodules "$REPO_URL" "$REPO_NAME"
  cd "$REPO_NAME"
fi

CONFIG_DIR="$HOME/$REPO_NAME/config-stow"

if [ ! -d "$CONFIG_DIR" ]; then
  echo "config-stow directory not found!"
  exit 1
fi

echo "Removing old configs that are managed by dotfiles..."
for folder in "$CONFIG_DIR"/*; do
  folder_name=$(basename "$folder")
  target="$HOME/.config/$folder_name"

  if [ -e "$target" ]; then
    echo "Removing: $target"
    rm -rf "$target"
  fi
done

echo "Stowing packages..."
cd "$CONFIG_DIR"
for folder in */ ; do
  [ -d "$folder" ] || continue
  echo "Stowing $folder..."
  stow -v "$folder" -t "$HOME/.config"
done

echo "Done."
cd "$ORIGINAL_DIR"

