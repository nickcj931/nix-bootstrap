#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Running disko"
sudo nix --experimental-features 'nix-command flakes' run github:nix-community/disko/latest -- \
  --mode destroy,format,mount --flake "$ROOT_DIR#generic-vm"

echo "==> Generating hardware configuration"
sudo nixos-generate-config --root /mnt

echo "==> Installing NixOS from flake"
sudo nixos-install --flake "$ROOT_DIR#generic-vm"

echo "==> Install complete"
echo "Reboot into the installed system. Cloud-Init SSH keys apply on first boot."
