# When using from a Flake, you can access these via imports of the attr key, e.g:
#
# imports = [
#   nixos-hardware.nixosModules.lenovo-yoga-7-14ARH7.amdgpu
# ];
#
## or:
# imports = [
#   nixos-hardware.nixosModules.lenovo-yoga-7-14ARH7.nvidia
# ];

{
  amdgpu = import ./amdgpu;
  nvidia = import ./nvidia;
}
