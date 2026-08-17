{ ... }:
{
  services.qemuGuest.enable = true;

  systemd.services.qemu-guest-agent.wantedBy = [ "multi-user.target" ];

  services.cloud-init = {
    enable = true;
    network = {
      enable = true;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
