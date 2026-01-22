{ ... }:
{
  imports = [ ../. ];

  # The open source driver does not support Fermi GPUs.
  hardware.nvidia.open = false;
}
