/*
 * `lenovo-yoga-7-14ARH7-nvidia`:
 *
 * This is a hybrid profile that enables the Nvidia
 * driver and PRIME for making use of both integrated
 * and dedicated graphics. Use this profile if you
 * want to use the Nvidia GPU.
 *
 * The `lenovo-yoga-7-14ARH7-amdgpu` profile only
 * has the integrated AMD GPU enabled. The dedicated
 * Nvidia GPU is disabled entirely. Use that profile
 * instead if you want to only use the integrated GPU.
 */
{
  imports = [
    ../shared.nix
    ../../shared/nvidia
  ];

  # Info: <https://wiki.nixos.org/wiki/NVIDIA#Common_setup>
  hardware.nvidia.prime.amdgpuBusId = "PCI:4:0:0";
}
