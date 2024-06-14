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
      # check for gppN, disable if enabled
      # lifted from  https://www.reddit.com/r/gigabyte/comments/p5ewjn/comment/ksbm0mb/ /u/Demotay
      ExecStart       = "-${pkgs.bash}/bin/bash -c 'if grep 'GPP0' /proc/acpi/wakeup | grep -q 'enabled'; then echo 'GPP0' > /proc/acpi/wakeup; fi'"; 
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
      ExecStart       = "-${pkgs.bash}/bin/bash -c 'if grep 'GPP8' /proc/acpi/wakeup | grep -q 'enabled'; then echo 'GPP8' > /proc/acpi/wakeup; fi'";
      RemainAfterExit = "yes";
    };
    wantedBy = ["multi-user.target"];
  };

}
