{ lib, config, ... }: {
  imports = [
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/maxwell
    ../../../common/cpu/intel
    ../.
  ];

  hardware = {
    nvidia = {
      prime = {
        intelBusId = lib.mkDefault "PCI:0:2:0";
        nvidiaBusId = lib.mkDefault "PCI:1:0:0";
      };
    };
  };

  # required to make wireless work
  hardware.enableAllFirmware = lib.mkDefault true;

  # fix suspend/resume screen corruption in sync mode
  hardware.nvidia.powerManagement =
    lib.mkIf config.hardware.nvidia.prime.sync.enable {
      enable = lib.mkDefault true;
    };

  # fix screen tearing in sync mode
  hardware.nvidia.modesetting =
    lib.mkIf config.hardware.nvidia.prime.sync.enable {
      enable = lib.mkDefault true;
    };

  # Make the DPI the same in sync mode as in offload mode (disabled because
  # these thinkpads come with many kinds of screens, but this is valid for the
  # 1920x1080 ones)
  #services.xserver.dpi = 96;

  # throttled vs. thermald
  # -----------------------
  #
  # NB: the p53 profile currently uses throttled to prevent too-eager CPU
  # throttling.  I understand throttled to have been a workaround solution at
  # the time the p53 profile was created (throttled's original name was
  # "lenovo_fix").  thermald would have been preferred if it worked at the
  # time.
  #
  # I read
  # https://wiki.archlinux.org/title/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues
  # as saying that thermald is fixed under the circumstance that led to the
  # development of throttled given version 5.12+ of the kernel combined
  # with version 2.4.3+ of thermald.  At the time of this writing, the
  # stable NixOS kernel is 5.15 and 2.4.9 of thermald.
  #
  # In the meantime, I also ran the "s-tui" program which can stress test the
  # system, while eyeing up the core temps and CPU frequency under three
  # scenarios: under thermald, under throttled, and with neither.  None of the
  # scenarios seem to have massively improved fan behavior, core temps, or
  # average CPU frequency than another.  The highest core temp always seems to
  # hover around 90 degrees C, the lowest CPU Ghz around 3.4 on a 3.8Ghz machine.
  #
  # I ended up choosing throttled because subjectively, the fans seem quieter
  # when it's stressed and it allows the average temps to get a degree or two
  # higher when running throttled than when running in the other two scenarios,
  # but still substantially under critical temp.

  services.throttled.enable = lib.mkDefault true;

}
