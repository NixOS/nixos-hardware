{
  imports = [ ./nvidia/disable.nix ];

  warnings = [
    ''
      DEPRECATED: The <nixos-hardware/common/gpu/nvidia-disable.nix> module has been deprecated.

      Switch to using <nixos-hardware/common/gpu/nvidia/disable.nix> instead.
    ''
  ];
}
