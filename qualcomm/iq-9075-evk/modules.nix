{
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.hostPlatform.system = "aarch64-linux";

  boot = {
    kernelPackages = pkgs.linuxPackagesFor pkgs.iq-9075-evk-linux;

    # Do not wrap in mkDefault: NixOS core (root=fstab / loglevel / lsm) is
    # priority 100, so mkDefault kernelParams are discarded entirely — the UKI
    # then boots with no console and hangs silently after ExitBootServices.
    #
    # QLI reference UKI cmdline:
    #   root=PARTLABEL=rootfs rw rootwait console=ttyMSM0,115200 qcom_scm.download_mode=1
    # Keep NixOS init=/nix/store/.../init + root=fstab from the module system;
    # match QLI console / scm / rw / rootwait.
    kernelParams = [
      "console=ttyMSM0,115200"
      "qcom_scm.download_mode=1"
      "rw"
      "rootwait"
    ];

    # IQ-9075 / meta-qcom is an EFI board (UEFI BDS → ESP).
    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault false;
      systemd-boot = {
        enable = lib.mkDefault true;
        # Embedded flash image; firmware vars are managed by Qualcomm BDS.
        editor = lib.mkDefault false;
      };
      efi = {
        canTouchEfiVariables = lib.mkDefault false;
        efiSysMountPoint = lib.mkDefault "/boot";
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
