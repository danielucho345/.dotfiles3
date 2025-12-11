#!/usr/bin/env bash
set -e

echo "Installing Rust stable toolchain..."
rustup install stable
rustup default stable

echo "Adding core components..."
rustup component add rustfmt
rustup component add clippy
rustup component add rust-analyzer
rustup component add llvm-tools-preview

echo "Installing cargo-based tools..."
cargo install grcov
cargo install cargo-binutils

echo "Applying Cargo configuration..."
mkdir -p ~/.cargo
cat << 'EOF' > ~/.cargo/config.toml
[build]
target-dir = "target"
incremental = true

[profile.release]
lto = true
codegen-units = 1
panic = "abort"
strip = true

[target.x86_64-unknown-linux-gnu]
linker = "cc"

[unstable]
build-std = ["std", "panic_abort"]
EOF

echo "Rust environment setup complete."
echo "Installed tools:"
echo "  - rustc"
echo "  - cargo"
echo "  - rustfmt"
echo "  - clippy"
echo "  - rust-analyzer"
echo "  - grcov"
echo "  - cargo-binutils"
