{lib, ...}:
{
  imports = [ ../. ];

  # The open source driver does not support Pascal GPUs.
  hardware.nvidia.open = false;
}
