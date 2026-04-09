#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT_FILE="$ROOT_DIR/install-debug.txt"
NIX_FLAGS=(--extra-experimental-features 'nix-command flakes')

exec > >(tee "$OUT_FILE") 2>&1

echo "==> nix-bootstrap installer debug"
echo "timestamp: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
echo "root_dir: $ROOT_DIR"
echo

echo "==> Running disko"
sudo nix --experimental-features 'nix-command flakes' run github:nix-community/disko/latest -- \
  --mode destroy,format,mount --flake "path:$ROOT_DIR#generic-vm"
echo

echo "==> Generating hardware configuration"
sudo nixos-generate-config --root /mnt
sudo cp /mnt/etc/nixos/hardware-configuration.nix "$ROOT_DIR/hardware-configuration.nix"
sudo chown "$(id -u)":"$(id -g)" "$ROOT_DIR/hardware-configuration.nix"
echo

echo "==> Basic mount checks"
findmnt /mnt || true
findmnt /mnt/boot || true
echo

echo "==> Block devices"
lsblk -o NAME,PATH,FSTYPE,PARTLABEL,PARTUUID,UUID,SIZE,MOUNTPOINTS
echo

echo "==> blkid"
sudo blkid || true
echo

echo "==> by-* symlinks"
ls -l /dev/disk/by-partlabel || true
ls -l /dev/disk/by-partuuid || true
ls -l /dev/disk/by-uuid || true
echo

echo "==> Generated hardware-configuration.nix"
sed -n '1,220p' "$ROOT_DIR/hardware-configuration.nix"
echo

echo "==> Evaluated fileSystems using path flake"
nix "${NIX_FLAGS[@]}" eval "path:$ROOT_DIR#nixosConfigurations.generic-vm.config.fileSystems" --json
echo

echo "==> Evaluated fileSystems using git flake"
(cd "$ROOT_DIR" && nix "${NIX_FLAGS[@]}" eval .#nixosConfigurations.generic-vm.config.fileSystems --json)
echo

echo "==> Summary"
echo "Debug output written to: $OUT_FILE"
echo "Copy it to ares with: scp \"$OUT_FILE\" root@ares:/root/vmNixFiles/install-debug.txt"
echo "Do not run nixos-install yet; inspect this file first."
