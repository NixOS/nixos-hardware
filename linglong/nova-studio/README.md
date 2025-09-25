# Linglong Nova Studio

This is a configuration for [Linglong Nova Studio (玲珑星核)](https://www.firstarpc.com/).

## Configuration

import `<nixos-hardware/linglong/nova-studio>` (using configurations), or add `nixos-hardware.nixosModules.linglong-nova-studio` in modules (using Flakes).

This configuration will force to use Linux kernel that >= 6.14, otherwise it will be updated to the latest version. This part follows [Framework Desktop](../../framework/desktop/amd-ai-max-300-series), which is also a desktop computer using Ryzen AI Max 300 series processor.

## OpenCL and ROCm support

To setup OpenCL and ROCm environment, please add the following configuration:

```
# Tell packages that supports ROCm to enable the related supports.
nixpkgs.config.rocmSupport = true;

# Install ROCm and enable
hardware.amdgpu.opencl.enable = true;

# These tools can show the info related to ROCm and OpenCL.
environment.systemPackages = with pkgs; [
  rocmPackages.rocminfo
  clinfo
];
```

After switching, to check whether the environment has been correctly setup, please run

```
clinfo
```

and

```
rocminfo
```
