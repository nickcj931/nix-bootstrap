# nix-bootstrap

A lightweight NixOS bootstrap repository designed to quickly deploy configured VMs using `disko` and Flakes. This version supports **Cloud-Init** for automated SSH key injection.

## Configure In One Place

Edit the `vmConfig` block in `flake.nix` before installing.

```nix
vmConfig = {
  diskDevice = "/dev/sda";
  diskSize = "100G";
  swapSize = "16G";
  hostPlatform = "x86_64-linux";
  stateVersion = "25.11";
  useCloudInitNetworking = true;
};
```

- `diskDevice`: target install disk inside the VM
- `diskSize`: size of the Btrfs root partition
- `swapSize`: size of the Btrfs swapfile
- `hostPlatform`: target system architecture
- `stateVersion`: NixOS state version for the installed system
- `useCloudInitNetworking`: when `true`, networking is managed by cloud-init/networkd; when `false`, fallback to standard DHCP config

## Prerequisites

Before booting the VM, configure Proxmox Cloud-Init to inject your SSH keys:

```bash
# Run on Proxmox host (e.g., ares)
qm set <VMID> --ipconfig0 ip=dhcp
qm set <VMID> --sshkey /root/.ssh/bootstrapKeys.pub
```

The bootstrap keys file is pre-configured at `/root/.ssh/bootstrapKeys.pub` on the Proxmox host.

With `useCloudInitNetworking = true`, DHCP is still used, but it is applied via cloud-init/networkd rather than `networking.useDHCP`.

## Installation (from NixOS Live ISO)

Once booted into the NixOS installer:

1. **Clone the repo**:
   ```bash
   git clone git@github.com:nickcj931/nix-bootstrap.git
   cd nix-bootstrap
   ```

2. **Run the bootstrap script**:
   ```bash
   ./install.sh
   ```

3. **Manual equivalent if needed**:
   ```bash
   sudo nix --experimental-features 'nix-command flakes' run github:nix-community/disko/latest -- \
     --mode destroy,format,mount ./modules/disko.nix
   sudo nixos-generate-config --root /mnt
   sudo nixos-install --flake .#generic-vm
   ```

4. **Reboot** into the installed system. SSH keys will be applied on first boot via Cloud-Init.

## Features

- **Automated Partitioning**: Uses `disko` for consistent Btrfs subvolume layouts.
- **Cloud-Init SSH Injection**: Keys are injected via Proxmox, no manual typing required.
- **Flake-based**: Reproducible and easy to extend.

## Repository Structure

- `flake.nix`: Main entry point (edit this to configure your VM).
- `modules/`: Contains reusable NixOS modules (`disko`, `ssh`).
- `README.md`: Usage instructions.
