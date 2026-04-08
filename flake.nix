{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, disko }: {
    nixosConfigurations.generic-vm = nixpkgs.lib.nixosSystem {
      modules = [
        disko.nixosModules.disko
        ./modules/ssh.nix
        {
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          networking.useDHCP = true;
        }
      ];
    };
  };
}
