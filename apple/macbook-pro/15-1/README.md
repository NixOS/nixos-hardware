# Grub setup

Here's a grub setup that worked for me.


```nix
  boot.loader = {
    grub = {
      device = "nodev";
      gfxmodeEfi = "1024x768";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    efi.efiSysMountPoint = "/boot";
  };
```

For dual boot, you may be able to
share darwin's bootloader under /boot/EFI as is
shown here: https://github.com/gilescope/dotgiles/blob/b59280ca0056c8ad93ae8330241671a3ba15e0c8/configuration.nix
But since it's an older mbp version with T1, the mbp15x(T2) may need to be
configured differently.
