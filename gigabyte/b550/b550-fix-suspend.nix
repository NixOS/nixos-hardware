{ pkgs, lib, ... } :

{
  systemd.services.bugfixSuspend-GPP0 = {
    enable            = lib.mkDefault true;
    description       = "Fix crash on wakeup from suspend/hibernate (b550 bugfix)";
    unitConfig = {
      Type            = "oneshot";
    };
    serviceConfig = {
      User            = "root"; # root may not be necessary
      ExecStart       = "-${pkgs.bash}/bin/bash -c 'echo 'GPP0' > /proc/acpi/wakeup'";
      RemainAfterExit = "yes";  # required to not toggle when `nixos-rebuild switch` is ran
      
    };
    wantedBy = ["multi-user.target"];
  };

  systemd.services.bugfixSuspend-GPP8 = {
    enable            = lib.mkDefault true;
    description       = "Fix crash on wakeup from suspend/hibernate (b550 bugfix)";
    unitConfig = {
      Type            = "oneshot";
    };
    serviceConfig = {
      User            = "root";
      ExecStart       = "-${pkgs.bash}/bin/bash -c 'echo 'GPP8' > /proc/acpi/wakeup'";
      RemainAfterExit = "yes";
    };
    wantedBy = ["multi-user.target"];
  };

}







