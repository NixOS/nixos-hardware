{ pkgs, ... }:
{
  imports = [
    ../../../../common/cpu/amd
    ../../../../common/cpu/amd/pstate.nix
    ../../../../common/cpu/amd/zenpower.nix
    ../../../../common/gpu/amd
    ../../../../common/hidpi.nix
    ../../../../common/pc
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  # Defer the following Stage 1 warning to Stage 2:
  #
  #     loading module amdgpu...
  #     [...] amdgpu 0000:05:00.0: amdgpu: Secure display: Generic Failure.
  #     [...] amdgpu 0000:05:00.0: amdgpu: SECUREDISPLAY: query securedisplay TA failed. ret 0x0
  hardware.amdgpu.initrd.enable = false;

  services.udev.extraRules = builtins.concatStringsSep "\n" (
    [ "# Properly suspend the system." ]
    ++ (map
      (
        device:
        ''SUBSYSTEM=="pci", ACTION=="add", ATTR{vendor}=="0x144d", ATTR{device}=="${device}", RUN+="${pkgs.runtimeShell} -c 'echo 0 > /sys/bus/pci/devices/$kernel/d3cold_allowed'"''
      )
      [
        "0xa80a"
        "0xa808"
      ]
    )
  );
}
