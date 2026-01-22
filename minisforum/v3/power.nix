{ pkgs, ... }:
{

  # From "Optimizing power draw (under Linux)": https://github.com/mudkipme/awesome-minisforum-v3/issues/5#issue-2391536450
  boot.kernelParams = [ "pcie_aspm.policy=powersupersave" ];
  systemd.services.enable-aspm = {
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash ${pkgs.callPackage ./src.nix { }}/aspm_v3.sh";
      Restart = "no";
    };

    path = with pkgs; [
      bc
      pciutils
    ];
  };

}
