{
  imports = [ ./intel ];

  warnings = [
    ''
      DEPRECATED: The <nixos-hardware/common/gpu/intel.nix> module has been deprecated.

      Switch to using <nixos-hardware/common/gpu/intel> instead.
    ''
  ];
}
