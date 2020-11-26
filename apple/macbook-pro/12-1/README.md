# MacBook Pro 12,1

## Wireless won't get reconnected after resume/hibernate

As an example similar code could be used to restart wireless interface:

```nix
powerManagement.powerUpCommands = ''
  ${pkgs.systemd}/bin/systemctl restart wpa_supplicant.service
'';
};
```

You can apply this to your network management software of choice.
