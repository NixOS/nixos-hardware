{
	imports = [
		../../../common/cpu/amd
		../../../common/cpu/amd/pstate.nix
		../../../common/gpu/nvidia
		../../../common/gpu/nvidia/prime.nix
		../../../common/gpu/nvidia/ampere
		../../../common/pc/laptop
		../../../common/pc/ssd
		../../battery.nix
	];

	hardware.nvidia.prime = {
    amdgpuBusId = "PCI:5:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
