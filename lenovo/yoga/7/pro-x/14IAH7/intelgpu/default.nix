/*
 * `lenovo-yoga-7-14IAH7-intelgpu`:
 *
 * This profile only has the integrated Intel GPU enabled.
 * The dedicated Nvidia GPU is disabled entirely.
 * Use this profile if you want to only use the
 * integrated GPU.
 *
 * The `lenovo-yoga-7-14IAH7-nvidia` hybrid profile
 * enables the Nvidia driver and PRIME for making use
 * of both GPUs. Use that profile instead if you want
 * to use the Nvidia GPU.
 */
{
  imports = [
    ../shared.nix
    ../../../../../../common/gpu/nvidia/disable.nix
  ];
}
