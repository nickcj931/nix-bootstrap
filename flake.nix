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
    "nixosConfigurations.generic": {
      "modules": [
        ./modules/disko.nix,
        ./modules/ssh.nix,
        {
          "imports": [
            "${inputs.nixpkgs}/nixos"
          ],
          "config": {
            "bootloader.systemd-boot.enable = true;",
            "bootloader.efi.canTouchEefiVariables = true;",
            "networking.useDHCP = true;",
            "disko.devices.disk.main.device = \"/dev/vda\";",
            "disko.devices.disk.main.rootSize = \"100G\";",
            "bootstrapping.sshKeys = [
              \"<INSERT YOUR KEY 1>\",
              \"<INSERT YOUR KEY 2>\"
            ];"
          }
        }
      ]
    }
  }
}
