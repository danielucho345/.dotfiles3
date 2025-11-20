
#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$DOTFILES_DIR/config"

echo "  ==== STARTING DOTFILES ======="
# Ensure stow is installed
if ! command -v stow >/dev/null 2>&1; then
  echo "Error: stow not found."
  exit 1
fi

# Ensure config folder exists
if [ ! -d "$CONFIG_DIR" ]; then
  echo "Error: $CONFIG_DIR does not exist."
  exit 1
fi

echo "=== Cleaning old configs in ~/.config… ==="

# Remove existing package folders/symlinks
for package in "$CONFIG_DIR"/*; do
  [ -d "$package" ] || continue
  pkgname=$(basename "$package")
  target="$HOME/.config/$pkgname"

  
  if [ -d "$target" ]; then
      echo "  ...Removing old/default config: $target"
      rm -rf "$target"
  fi

  if [ ! -L "$target" ]; then 
    echo "  ...Creating folder for stow... $target" 
    mkdir  "$target"
  fi 
done


# Stow each package as a whole folder
for package in "$CONFIG_DIR"/*; do
  [ -d "$package" ] || continue
  pkgname=$(basename "$package")
  echo "  Stowing $pkgname"
  echo "  stow comand --verbose --dir="$CONFIG_DIR" --target="$HOME/.config/$pkgname""
  stow --verbose --dir="$CONFIG_DIR" --target="$HOME/.config/$pkgname" "$pkgname" || echo "ERROR STOWING $pkgname"
done

echo "Dotfiles installed successfully."


echo "  ==== DONE DOTFILES ======="
