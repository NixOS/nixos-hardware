{ lib, ... }:
{
  imports = [
    ../../../common/gpu/nvidia.nix
    ../../../common/cpu/intel
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc/laptop/acpi_call.nix
    ../.
  ];

  hardware = {
    nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # is this too much?  It's convenient for Steam.
    opengl = {
      driSupport = lib.mkDefault true;
      driSupport32Bit = lib.mkDefault true;
    };
  };

  # Sleep
  # -----
  #
  # The system will not resume from sleep properly while on battery power in
  # either offload mode or sync mode.  When it tries to resume, it gets to a
  # state with a cursor in the top left hand side of the panel, the power LED
  # goes from flashing to solid, and thereafter cannot be interacted with (even
  # over SSH) and must be power cycled forcefully.  Sometimes it doesn't even
  # finish going to sleep before this behavior kicks in.
  #
  # When on AC, the machine either wakes up from sleep before being asked to
  # (or maybe never gets to sleep state), or it goes into a sleep state and it
  # appears consistently resume properly when it does.
  #
  # But the machine actually sleeps and resumes reliably when tlp is disabled
  # fully or partially.  Disabling RUNTIME_PM and AHCI_RUNTIME_PM appears to be
  # enough to allow it to work when tlp is active.  I couldn't figure out a
  # more granular way to get it working, despite trying to do a per-device
  # binary search via powertop.
  #
  # My personal configuration to make sleep work looks like this:
  #
  # {config, lib, ...}:
  #
  # {
  #   services.tlp = {
  #     settings = {
  #       # DISK_DEVICES must be specified for AHCI_RUNTIME_PM settings to work right.
  #       DISK_DEVICES = "nvme0n1 nvme1n1 sda sdb";
  #
  #       # with AHCI_RUNTIME_PM_ON_AC/BAT set to defaults in battery mode, P51
  #       # can't resume from sleep and P50 can't go to sleep.
  #       AHCI_RUNTIME_PM_ON_AC = "on";
  #       AHCI_RUNTIME_PM_ON_BAT = "on";
  #
  #       # with RUNTIME_PM_ON_BAT/AC set to defaults, P50/P51 can't go to sleep
  #       RUNTIME_PM_ON_AC = "on";
  #       RUNTIME_PM_ON_BAT = "on";
  #     };
  #   };
  # }
  #
  # I'm thinking this is too aggressive to put into shared config, and folks may
  # be concerned with the hit on battery life.
  #
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
