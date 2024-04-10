{ lib, pkgs, ... }:

{
  imports = [
    ../../../../lenovo/thinkpad/z
  ];

  # Kernel 6.4 is required for the Ryzen 7040 series
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.4") (lib.mkDefault pkgs.linuxPackages_latest);

  systemd.services = {
    # Modified from Arch Wiki
    "touchpad-fix" = {
      enable = lib.mkDefault true;
      description = "I2C HID devices can fail to initialize so try to reload";
      unitConfig = {
        Type = "oneshot";
      };
      serviceConfig = {
        User = "root";
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      script = ''
        count=0
        while true; do
            ${lib.getExe pkgs.libinput} list-devices | ${lib.getExe pkgs.gnugrep} --quiet SNSL && break
            count=$((count + 1))

            if test $count -ge 5; then
                echo "Touchpad not read after $count attempts"
                break
            fi

            echo "Touchpad not ready; attempt $count to reload"
            ${pkgs.kmod}/bin/rmmod i2c_hid_acpi
            ${pkgs.kmod}/bin/modprobe i2c_hid_acpi

            sleep $((2 + (count * 3)))
        done
      '';
    };
  };
}
