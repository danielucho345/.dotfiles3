#!/bin/bash

INSTALL_DIR="./install"

# Arrays to keep track of success/failure
echo "====== START Main Installator ======"
success=()
failure=()

# Ensure the install directory exists
if [ ! -d "$INSTALL_DIR" ]; then
  echo "Install directory not found: $INSTALL_DIR"
  exit 1
fi

echo "=== Installing packages ==="
# Iterate over all .sh files in the install folder
for script in "$INSTALL_DIR"/*.sh; do
  # Ensure the script is executable
  [ -x "$script" ] || chmod +x "$script"

  echo "Running $script..."
  
  # Run the script but don't exit on failure
  if "$script"; then
    echo "✅ $script succeeded"
    success+=("$(basename "$script")")
  else
    echo "❌ $script failed"
    failure+=("$(basename "$script")")
  fi
done

echo "=== Finish Installing packages ==="

echo "installing .dotfiles git submodules..."

./install-dotfiles.sh

# Print summary
echo
echo "========== INSTALL SUMMARY =========="
echo "Successful installs:"
for s in "${success[@]}"; do
  echo "  - $s"
done

if [ ${#failure[@]} -ne 0 ]; then
  echo
  echo "Failed installs:"
  for f in "${failure[@]}"; do
    echo "  - $f"
  done
else
  echo
  echo "All scripts ran successfully!"
fi

echo "====== FINISH Main Installator ======"
