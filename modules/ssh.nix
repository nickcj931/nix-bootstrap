{
  "services.cloud-init": {
    "enable": true,
    "network": {
      "enable": true,
      "dhcp": true
    },
    "users": {
      "users.root.openssh.authorizedKeys.keys": [
        "<INSERT YOUR KEY 1>",
        "<INSERT YOUR KEY 2>"
      ]
    }
  },
  "services.openssh": {
    "enable": true,
    "settings": {
      "PasswordAuthentication": false,
      "KbdInteractiveAuthentication": false
    }
  }
}
