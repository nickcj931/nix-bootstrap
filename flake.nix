{
  "inputs": {
    "nixpkgs": {
      "follows": "nixpkgs",
      "url": "github:NixOS/nixpkgs/nixos-unstable"
    },
    "disko": {
      "url": "github:nix-community/disko"
    }
  },
  "outputs": {
    "nixosConfigurations.generic-vm": {
      "modules": [
        ./modules/disko.nix,
        ./modules/ssh.nix,
        {
          "imports": [
            "${inputs.nixpkgs}/nixos"
          ],
          "config": {
            "bootloader.systemd-boot.enable = true;",
            "bootloader.efi.canTouchEfiVariables = true;",
            "networking.useDHCP = true;"
          }
        }
      ]
    }
  }
}
