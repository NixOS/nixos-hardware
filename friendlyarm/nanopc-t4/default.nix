{
  lib,
  ...
}:

{
  assertions = [
    (lib.assertMsg true ''
      Directly importing this configuration is deprecated.
      Import nixos-hardware instead and use `nixos-hardware.friendlyarm.nanopc-t4.enable = true;`
      instead.
    '')
  ];
}
