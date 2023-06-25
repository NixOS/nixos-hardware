## When using from a Flake, you can access these via imports of the attr key, e.g:
#
# imports = [
#   nixos-hardware.nixosModules.asus-zephyrus-ga402x.amdgpu
# ];
#
## or:
# imports = [
#   nixos-hardware.nixosModules.asus-zephyrus-ga402x.nvidia
# ];

{
  amdgpu = import ./amdgpu;
  nvidia = import ./nvidia;
}
