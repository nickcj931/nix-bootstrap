#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Running disko"
sudo nix --experimental-features 'nix-command flakes' run github:nix-community/disko/latest -- \
  --mode destroy,format,mount --flake "$ROOT_DIR#generic-vm"

echo "==> Generating hardware configuration (filesystems handled by disko)"
sudo nixos-generate-config --no-filesystems --root /mnt

echo "==> Copying generated hardware configuration into repo"
sudo cp /mnt/etc/nixos/hardware-configuration.nix "$ROOT_DIR/hardware-configuration.nix"
sudo chown "$(id -u)":"$(id -g)" "$ROOT_DIR/hardware-configuration.nix"

echo "==> Staging hardware config so the flake can see it"
git -C "$ROOT_DIR" add -f hardware-configuration.nix

echo "==> Installing NixOS from flake"
sudo nixos-install --flake "$ROOT_DIR#generic-vm"

echo "==> Install complete"
echo "Reboot into the installed system. Cloud-Init SSH keys apply on first boot."
