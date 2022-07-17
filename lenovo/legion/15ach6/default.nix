{ lib, config, ... }:
let kernelPackages = config.boot.kernelPackages;
in {
  imports = [
    ../../../common/cpu/amd
    ../../../common/gpu/amd
    ../../../common/gpu/nvidia.nix
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:5:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services.thermald.enable = lib.mkDefault true;

  # https://wiki.archlinux.org/title/backlight#Backlight_is_always_at_full_brightness_after_a_reboot_with_amdgpu_driver
  systemd.services.fix-brightness = {
    before = [
      "systemd-backlight@backlight:${
        if lib.versionOlder kernelPackages.kernel.version "5.18" then "amdgpu_bl0" else "nvidia_wmi_ec_backlight"
      }.service"
    ];
    description = "Convert 16-bit brightness values to 8-bit before systemd-backlight applies it";
    script = ''
      BRIGHTNESS_FILE="/var/lib/systemd/backlight/${
        if lib.versionOlder kernelPackages.kernel.version "5.18" then
          "pci-0000:05:00.0:backlight:amdgpu_bl0"
        else
          "platform-PNP0C14:00:backlight:nvidia_wmi_ec_backlight"
      }"
      BRIGHTNESS=$(cat "$BRIGHTNESS_FILE")
      BRIGHTNESS=$(($BRIGHTNESS*255/65535))
      BRIGHTNESS=''${BRIGHTNESS/.*} # truncating to int, just in case
      echo $BRIGHTNESS > "$BRIGHTNESS_FILE"
    '';
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
  };
}
