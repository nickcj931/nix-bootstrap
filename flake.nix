{
  description = "Generic NixOS VM bootstrap with disko and cloud-init";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, disko }:
  let
    vmConfig = {
      diskDevice = "/dev/sda";
      swapSize = "16G";
      hostPlatform = "x86_64-linux";
      stateVersion = "25.11";
      useCloudInitNetworking = true;
    };
  in {
    nixosConfigurations.generic-vm = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit vmConfig; };
      modules = [
        disko.nixosModules.disko
        ./modules/disko.nix
        ./modules/ssh.nix
        {
          nixpkgs.hostPlatform = vmConfig.hostPlatform;

          # Match the installer environment expectation for EFI installs.
          boot.loader.grub.enable = false;
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          boot.loader.efi.efiSysMountPoint = "/boot";
          fileSystems."/boot".neededForBoot = true;

          networking.useDHCP = !vmConfig.useCloudInitNetworking;
          networking.useNetworkd = vmConfig.useCloudInitNetworking;

          system.stateVersion = vmConfig.stateVersion;
        }
      ];
    };
  };
}
