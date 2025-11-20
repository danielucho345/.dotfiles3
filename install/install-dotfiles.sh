#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$DOTFILES_DIR/config"

if ! command -v stow >/dev/null 2>&1; then
  echo "Error: stow not found."
  exit 1
fi

if [ ! -d "$CONFIG_DIR" ]; then
  echo "Error: $CONFIG_DIR does not exist."
  exit 1
fi

echo "Cleaning old configs from stowed packages…"

for package in "$CONFIG_DIR"/*; do
  [ -d "$package" ] || continue
  pkgname=$(basename "$package")
  echo "  Processing package: $pkgname"
  for root in "$package"/*; do
    [ -d "$root" ] || continue
    root_folder=$(basename "$root")
    for item in "$root"/*; do
      [ -e "$item" ] || continue
      item_name=$(basename "$item")
      target="$HOME/$root_folder/$item_name"

      echo "$target $item_name"
      if [ -e "$target" ] || [ -L "$target" ]; then
        echo "    Removing: $target"
        rm -rf "$target"
      fi
    done
  done
done

echo "Stowing packages…"
cd "$CONFIG_DIR"

for package in */ ; do
  pkgname=$(basename "$package")
  echo "  Stowing $pkgname"
  stow --verbose --dir="$CONFIG_DIR" --target="$HOME" "$pkgname"
done

echo "Dotfiles installed successfully."

