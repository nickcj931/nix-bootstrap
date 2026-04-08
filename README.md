# nix-bootstrap

A lightweight NixOS bootstrap repository designed to quickly deploy configured VMs using `disko` and Flakes.

## Quick Start (from NixOS Live ISO)

Once booted into the NixOS installer:

1. **Clone the repo**:
   ```bash
   git clone git@github.com:nickcj931/nix-bootstrap.git
   cd nix-bootstrap
   ```

2. **Configure your variables**:
   Edit `flake.nix` to set your preferred disk size, device path, and SSH keys.
   *Note: Do not commit your actual SSH keys to a public repository! Use the placeholder values as a guide.*

3. **Run the installation**:
   ```bash
   sudo nixos-install --flake .#generic
   ```

## Features

- **Automated Partitioning**: Uses `disko` for consistent Btrfs subvolume layouts.
- **Pre-configured SSH**: Includes authorized keys via configurable module.
- **Flake-based**: Reproducible and easy to extend.

## Repository Structure

- `flake.nix`: Main entry point (edit this to configure your VM).
- `modules/`: Contains reusable NixOS modules (`disko`, `ssh`).
- `README.md`: Usage instructions.
