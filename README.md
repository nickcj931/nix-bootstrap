# nix-bootstrap

A lightweight NixOS bootstrap repository designed to quickly deploy configured VMs using `disko` and Flakes. This version supports **Cloud-Init** for automated SSH key injection.

## Quick Start (from NixOS Live ISO)

Once booted into the NixOS installer:

1. **Clone the repo**:
   ```bash
   git clone git@github.com:nickcj931/nix-bootstrap.git
   cd nix-bootstrap
   ```

2. **Configure Proxmox Cloud-Init (on your Host)**:
   Before booting the VM, inject your SSH keys using the Proxmox CLI to avoid manual typing in the console:
   ```bash
   # Replace <VMID> with your target VM ID
   qm set <VMID> --ipconfig0 ip=dhcp
   qm set <VMID> --sshkey /path/to/your/public_key.pub
   ```

3. **Run the installation**:
   ```bash
   sudo nixos-install --flake .#generic-vm
   ```

## Features

- **Automated Partitioning**: Uses `disko` for consistent Btrfs subvolume layouts.
- **Cloud-Init Support**: Enables seamless, headless SSH key injection.
- **Flake-based**: Reproducible and easy to extend.

## Repository Structure

- `flake.nix`: Main entry point (edit this to configure your VM).
- `modules/`: Contains reusable NixOS modules (`disko`, `ssh`).
- `README.md`: Usage instructions.
