## Switching Cmd and Alt/AltGr

This will switch the left Alt and Cmd key as well as the right Alt/AltGr and Cmd key. 

```nix
boot.kernelParams = [
  "hid_apple.swap_opt_cmd=1"
];
```

Reference: https://wiki.archlinux.org/index.php/Apple_Keyboard#Switching_Cmd_and_Alt/AltGr
