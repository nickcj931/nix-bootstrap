{ lib, ... }:
{
  options.bootstrapping.sshKeys = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "List of SSH public keys for the root user.";
  };

  config = {
    users.users.root.openssh.authorizedKeys.keys = config.bootstrapping.sshKeys;
    services.openssh.enable = true;
    services.openssh.settings.PasswordAuthentication = false;
    services.openssh.settings.KbdInteractiveAuthentication = false;
  };
}
