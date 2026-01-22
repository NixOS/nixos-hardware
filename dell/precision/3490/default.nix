{
  warnings = [
    ''
      DEPRECATED: The <nixos-hardware/dell/precision/3490> module has been deprecated.

      Either use
        <nixos-hardware/dell/precision/3490/nvidia>
      for NVIDIA graphics or
        <nixos-hardware/dell/precision/3490/intel>
      for Intel graphics.
    ''
  ];
  imports = [
    ./nvidia/default.nix
  ];
}
