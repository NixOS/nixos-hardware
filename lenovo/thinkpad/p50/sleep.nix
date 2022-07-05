# Sleep
# -----
#
# Without this configuration, the system will not resume from sleep properly
# while on battery power in either offload mode or sync mode.  When it tries to
# resume, it gets to a state with a cursor in the top left hand side of the
# panel, the power LED goes from flashing to solid, and thereafter cannot be
# interacted with (even over SSH) and must be power cycled forcefully.
# Sometimes it doesn't even finish going to sleep before this behavior kicks
# in.
#
# When on AC, the machine either wakes up from sleep before being asked to
# (or maybe never gets to sleep state), or it goes into a sleep state and it
# appears consistently resume properly when it does.
#
# But the machine actually sleeps and resumes reliably when tlp is disabled
# fully or partially.  Disabling RUNTIME_PM and AHCI_RUNTIME_PM appears to be
# enough to allow it to work when tlp is active.  This will negatively effect
# battery life.  I couldn't figure out a more granular way to get it working,
# despite trying to do a per-device binary search via powertop.
#

{config, lib, ...}:

{
  services.tlp = {
    settings = {
      # DISK_DEVICES must be specified for AHCI_RUNTIME_PM settings to work right.
      DISK_DEVICES = "nvme0n1 nvme1n1 sda sdb";

      # with AHCI_RUNTIME_PM_ON_AC/BAT set to defaults in battery mode, P51
      # can't resume from sleep and P50 can't go to sleep.
      AHCI_RUNTIME_PM_ON_AC = "on";
      AHCI_RUNTIME_PM_ON_BAT = "on";

      # with RUNTIME_PM_ON_BAT/AC set to defaults, P50/P51 can't go to sleep
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "on";
    };
  };
}
