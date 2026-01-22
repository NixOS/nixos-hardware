# MacBook Pro 12,1

## Wireless won't get reconnected after resume/hibernate

The wifi driver is unloaded before suspend/hibernate to workaround driver issues.
This means it might be required to restart your wifi deamon i.e. wpa_supplicant:

```nix
powerManagement.powerUpCommands = ''
  ${pkgs.systemd}/bin/systemctl restart wpa_supplicant.service
'';
```

You can apply this to your network management software of choice.
