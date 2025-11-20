
#!/bin/bash
set -euo pipefail

SOURCE_DIR="$(dirname "$0")/desktop-apps"
TARGET_DIR="$HOME/.local/share/applications"

# Ensure directories exist
mkdir -p "$TARGET_DIR"

echo "=== Desktop Application Override Installer ==="
echo "Source directory: $SOURCE_DIR"
echo "Target directory: $TARGET_DIR"
echo

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: $SOURCE_DIR does not exist."
    exit 1
fi

# Iterate through every .desktop file in desktop-apps
shopt -s nullglob
for desktop_file in "$SOURCE_DIR"/*.desktop; do
    filename=$(basename "$desktop_file")
    system_path="/usr/share/applications/$filename"
    target_path="$TARGET_DIR/$filename"

    echo "Processing: $filename"

    # Warn if the system version exists
    if [ -f "$system_path" ]; then
        echo "  → System file detected: $system_path"
        echo "    (Will be overridden in user directory)"
    else
        echo "  → No system file exists. Installing new launcher."
    fi

    # Copy your version
    echo "  → Installing user override: $target_path"
    cp "$desktop_file" "$target_path"

    # Update desktop database (safe, recommended)
    update-desktop-database "$TARGET_DIR" >/dev/null 2>&1 || true

    echo "  ✓ Completed override for $filename"
    echo
done

echo "All desktop applications processed successfully."

