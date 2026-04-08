{ lib, ... }:
let
  diskDevice = lib.mkOption {
    type = lib.types.str;
    default = "/dev/vda";
    description = "The device to partition and format.";
  };

  rootSize = lib.mkOption {
    type = lib.types.str;
    default = "100G";
    description = "The size of the main root partition.";
  };

  commonMountOptions = [ "compress=zstd" "noatime" ];
  relatimeMountOptions = [ "compress=zstd" ];
in
{
  options.disko.devices.disk.main = {
    type = lib.types.str;
    default = "disk";
  };

  config = {
    disko.devices.disk.main = {
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
            size = "${rootSize}";
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/";
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
                  swap.swapfile.size = "16G";
                };
              };
            };
          };
        };
      };
    };
  };
}
