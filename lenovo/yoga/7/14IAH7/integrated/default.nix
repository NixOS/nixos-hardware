/*
 * `lenovo-yoga-7-14IAH7-integrated`:
 *
 * This profile only has the integrated Intel GPU
 * enabled. The dedicated NVIDIA GPU is disabled
 * entirely. Use this profile if you want to only
 * use the integrated GPU.
 *
 * It is recommended to use this profile to disable
 * dedicated graphics, rather than doing it through
 * the BIOS, since that method causes issues with
 * the integrated graphics drivers. Doing it
 * through blacklisting achieves the same result
 * with no side-effects.
 *
 * The `lenovo-yoga-7-14IAH7-hybrid` hybrid profile
 * enables the NVIDIA driver and PRIME offload mode
 * for making use of both GPUs. Use that profile
 * instead if you want to use the NVIDIA GPU.
 * Read about PRIME offload mode here:
 * <https://wiki.nixos.org/wiki/NVIDIA#Offload_mode>
 */
{
  imports = [
    ../shared.nix
    ../../../../../common/gpu/nvidia/disable.nix
  ];
}
