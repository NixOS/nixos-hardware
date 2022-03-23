{ lib, ... }: {
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
    before = [ "systemd-backlight@backlight:amdgpu_bl0.service" ];
    description = "Convert 16-bit brightness values to 8-bit before systemd-backlight applies it";
    script = ''
      BRIGHTNESS_FILE="/var/lib/systemd/backlight/pci-0000:05:00.0:backlight:amdgpu_bl0"
      BRIGHTNESS=$(cat "$BRIGHTNESS_FILE")
      BRIGHTNESS=$(($BRIGHTNESS*255/65535))
      BRIGHTNESS=''${BRIGHTNESS/.*} # truncating to int, just in case
      echo $BRIGHTNESS > "$BRIGHTNESS_FILE"
    '';
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
  };
}
