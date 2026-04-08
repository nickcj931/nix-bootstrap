# nix-bootstrap

## Verify Before Editing
- Run `nix flake check` from the repo root after any `.nix` change. This repo recently had JSON-style syntax regressions in `.nix` files.

## Main Entry Point
- The install target is `.#generic-vm`.
- User-editable settings live in the single `vmConfig` block in `flake.nix`. Keep new top-level install knobs there unless there is a strong reason not to.

## Disk Layout
- `modules/disko.nix` is a disko module, not a generic options module. Do not reintroduce `mkOption` definitions under `disko.devices...`; that breaks disko evaluation.
- Current disk assumptions are driven through `specialArgs.vmConfig`: `diskDevice` and `swapSize`.
- Root filesystem is Btrfs with subvolumes for `/`, `/home`, `/nix`, `/var`, `/var/log`, `/.snapshots`, and `/.swapvol`.
- Root partition should stay `size = "100%"`; fixed root partition sizing caused guest partitioning failures during Proxmox installs.

## Networking
- `useCloudInitNetworking = true` does not disable DHCP in practice; it switches DHCP management to cloud-init/networkd.
- If you change cloud-init networking behavior, re-run `nix flake check` and keep README wording aligned so users do not think DHCP is disabled.

## SSH Injection
- SSH keys are not stored in this repo.
- Expected workflow is Proxmox-side injection before install:
  - `qm set <VMID> --ipconfig0 ip=dhcp`
  - `qm set <VMID> --sshkey /root/.ssh/bootstrapKeys.pub`
- `modules/ssh.nix` should only enable `services.cloud-init` and `services.openssh`; do not hardcode keys back into the module.

## Install Flow
- From the live ISO:
  - `git clone git@github.com:nickcj931/nix-bootstrap.git`
  - `cd nix-bootstrap`
  - `sudo nix --experimental-features 'nix-command flakes' run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#generic-vm`
  - `sudo nixos-generate-config --root /mnt`
  - `sudo nixos-install --flake .#generic-vm`
- If disko is not run first, bootloader install will fail because `/boot` will not actually exist as a mounted EFI partition.
- Do not run disko directly against `./modules/disko.nix`; it depends on `vmConfig` from the flake via `specialArgs`.
- Cloud-Init keys apply on first boot of the installed system, not inside the live installer environment.

## Repo Scope
- This repo is intentionally small: `flake.nix` wires the system, `modules/disko.nix` defines storage, `modules/ssh.nix` enables Cloud-Init/SSH, and `README.md` is the user workflow doc.
