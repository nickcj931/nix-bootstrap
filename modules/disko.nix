{ lib, vmConfig, ... }:
let
  diskDevice = lib.mkDefault vmConfig.diskDevice;
  commonMountOptions = [ "compress=zstd" "noatime" ];
  relatimeMountOptions = [ "compress=zstd" ];
in
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = diskDevice;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            label = "EFI";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          root = {
            size = vmConfig.diskSize;
            type = "8300";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/@root" = {
                  mountpoint = "/";
                  mountOptions = relatimeMountOptions;
                };
                "/@home" = {
                  mountpoint = "/home";
                  mountOptions = relatimeMountOptions;
                };
                "/@nix" = {
                  mountpoint = "/nix";
                  mountOptions = commonMountOptions;
                };
                "/@var" = {
                  mountpoint = "/var";
                  mountOptions = relatimeMountOptions;
                };
                "/@log" = {
                  mountpoint = "/var/log";
                  mountOptions = commonMountOptions;
                };
                "/@snapshots" = {
                  mountpoint = "/.snapshots";
                  mountOptions = commonMountOptions;
                };
                "/@swap" = {
                  mountpoint = "/.swapvol";
                  swap.swapfile.size = vmConfig.swapSize;
                };
              };
            };
          };
        };
      };
    };
  };
}
