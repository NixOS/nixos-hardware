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
		amdgpuBusId = "PCI:05:00:0";
		nvidiaBusId = "PCI:01:00:0";
	};
}
