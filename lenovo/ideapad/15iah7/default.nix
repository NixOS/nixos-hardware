{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ampere
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  users.groups.ideapad_laptop = { };

  systemd.tmpfiles.rules =
    map (node: "z /sys/bus/platform/drivers/ideapad_acpi/*/${node} 0664 - ideapad_laptop -")
      [
        "conservation_mode"
        "camera_power"
        "fan_mode"
        "fn_lock"
        "touchpad"
        "usb_charging"
      ];

  boot.kernelModules = [
    "ideapad_laptop"
  ];

  hardware.nvidia.prime = {
    intelBusId = lib.mkDefault "PCI:0:2:0";
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
  };
}
