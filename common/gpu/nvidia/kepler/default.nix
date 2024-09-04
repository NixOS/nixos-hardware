{lib, ...}:
{
  imports = [ ../. ];

  # The open source driver does not support Kepler GPUs.
  hardware.nvidia.open = false;
}
