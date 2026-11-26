{
  lib,
  ...
}:

{
  assertions = [
    (lib.assertMsg true ''
      Directly importing this configuration is deprecated.
      Import nixos-hardware instead and use `nixos-hardware.friendlyarm.nanopi-r5s.enable = true;`
      instead.
    '')
  ];
}
