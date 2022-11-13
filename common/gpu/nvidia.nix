{
  imports = [ ./nvidia/prime.nix ];

  warnings = [
    ''
      DEPRECATED: The <nixos-hardware/common/gpu/nvidia.nix> module has been deprecated.

      Switch to using <nixos-hardware/common/gpu/nvidia/prime.nix> instead if you use prime offloading.
      If you are using this without prime, consider switching to <nixos-hardware/common/gpu/nvidia> instead.
    ''
  ];
}
