{
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.hostPlatform.system = "aarch64-linux";
  # QCS9100 NHLOS boot zip from Qualcomm softwarecenter (unfree).
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  boot = {
    kernelPackages = pkgs.linuxPackagesFor pkgs.iq-9075-evk-linux;

    kernelParams = lib.mkDefault [
      "console=ttyMSM0,115200n8"
      "root=PARTLABEL=rootfs"
      "rw"
      "rootwait"
      "clk_ignore_unused"
      "pd_ignore_unused"
    ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible = {
        enable = lib.mkDefault true;
        useGenerationDeviceTree = true;
      };
    };

    initrd.includeDefaultModules = lib.mkForce false;
  };

  disabledModules = [ "profiles/all-hardware.nix" ];

  hardware = {
    deviceTree.enable = true;
    enableRedistributableFirmware = lib.mkDefault true;
  };
}
