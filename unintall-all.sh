
#!/bin/bash
set -e

INSTALL_DIR="./install"

removed=()
not_removed=()

for script in "$INSTALL_DIR"/*.sh; do
    echo "Processing $script..."

    # Extract pacman and yay install lines, remove flags, keep package names
    packages=$(grep -E "^(sudo )?(pacman|yay) -S" "$script" | \
               sed -E 's/^(sudo )?(pacman|yay) -S(--noconfirm)? //g' | tr '\n' ' ')

    [ -z "$packages" ] && continue

    for pkg in $packages; do
        if pacman -Qi "$pkg" &>/dev/null || yay -Qi "$pkg" &>/dev/null; then
            echo "Removing $pkg..."
            if sudo pacman -Rns --noconfirm "$pkg" 2>/dev/null; then
                removed+=("$pkg")
            else
                if yay -Rns --noconfirm "$pkg" 2>/dev/null; then
                    removed+=("$pkg")
                else
                    not_removed+=("$pkg")
                fi
            fi
        else
            not_removed+=("$pkg")
        fi
    done
done

# Summary
echo
echo "========== UNINSTALL SUMMARY =========="
if [ ${#removed[@]} -ne 0 ]; then
    echo "Successfully removed:"
    for p in "${removed[@]}"; do
        echo "  - $p"
    done
fi

if [ ${#not_removed[@]} -ne 0 ]; then
    echo
    echo "Could not remove (not installed or failed):"
    for p in "${not_removed[@]}"; do
        echo "  - $p"
    done
fi
echo "======================================"

