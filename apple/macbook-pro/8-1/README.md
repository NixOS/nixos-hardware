# MacBook Pro 8,1

## Enable unfree packages in your nix config for b43-firmware (wifi driver) to work

### For b43-firmware only (Ideal)

```nix
{lib, ...}:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "b43-firmware"
  ];
}

```

### For all packages

```nix
{
  nixpkgs.config.allowUnfree = true;
}
```
