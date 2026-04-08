# nix-bootstrap

A lightweight NixOS bootstrap repository designed to quickly deploy configured VMs using `disko` and Flakes. This version supports **Cloud-Init** for automated SSH key injection.

## Prerequisites

Before booting the VM, configure Proxmox Cloud-Init to inject your SSH keys:

```bash
# Run on Proxmox host (e.g., ares)
qm set <VMID> --ipconfig0 ip=dhcp
qm set <VMID> --sshkey /root/.ssh/bootstrapKeys.pub
```

The bootstrap keys file is pre-configured at `/root/.ssh/bootstrapKeys.pub` on the Proxmox host.

## Installation (from NixOS Live ISO)

Once booted into the NixOS installer:

1. **Clone the repo**:
   ```bash
   git clone git@github.com:nickcj931/nix-bootstrap.git
   cd nix-bootstrap
   ```

2. **Run the installation**:
   ```bash
   sudo nixos-install --flake .#generic-vm
   ```

3. **Reboot** into the installed system. SSH keys will be applied on first boot via Cloud-Init.

## Features

- **Automated Partitioning**: Uses `disko` for consistent Btrfs subvolume layouts.
- **Cloud-Init SSH Injection**: Keys are injected via Proxmox, no manual typing required.
- **Flake-based**: Reproducible and easy to extend.

## Repository Structure

- `flake.nix`: Main entry point (edit this to configure your VM).
- `modules/`: Contains reusable NixOS modules (`disko`, `ssh`).
- `README.md`: Usage instructions.
