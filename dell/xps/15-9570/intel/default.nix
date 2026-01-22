{
  imports = [
    ../../../../common/gpu/nvidia/disable.nix
    ../shared.nix
  ];

  # Disables the Nvidia GPU, better for battery life
}
