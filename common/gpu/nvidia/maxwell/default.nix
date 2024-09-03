{lib, ...}:
{
  imports = [ ../. ];

  # The open source driver does not support Maxwell GPUs.
  hardware.nvidia.open = false;
}
