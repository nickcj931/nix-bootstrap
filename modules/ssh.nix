{ ... }:
{
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
