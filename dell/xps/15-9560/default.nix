{
  imports = [
    ../../../common/cpu/intel
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc/laptop
    ./xps-common.nix

    # FIXME: remove this when bumblebee works again
    ../../../common/gpu/nvidia/disable.nix
  ];


  /* Bumblebee seems to fail to evaluate:
    (stack trace truncated; use '--show-trace' to show the full trace)

  error: assertion '(useSettings -> (! libsOnly))' failed

  at /home/joerg/git/nixpkgs/pkgs/os-specific/linux/nvidia-x11/generic.nix:61:1:

      60|
      61| assert useSettings -> !libsOnly;
        | ^
      62| assert !libsOnly -> kernel != null;

  # This configuration makes intel default and optionaly applications could run nvidia with optirun.
  # To Optimize for your use case import intel or nvidia only configuration instead
  # xps-9560/intel
  # or
  # xps-9560/nvidia


  ##### bumblebee working, needs reboot to take affect and to use it run: optirun "<application>"
  services.xserver.videoDrivers = [ "intel" "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" "bbswitch" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  hardware.bumblebee.enable = lib.mkDefault true;
  hardware.bumblebee.pmMethod = lib.mkDefault "none";
  */
}
