{ lib, pkgs, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
  ];

  # Necessary for audio.
  # https://bbs.archlinux.org/viewtopic.php?pid=1933643#p1933643
  hardware.firmware = [ pkgs.sof-firmware ];

  # Confirmed necessary to get audio working as of 2020-11-13:
  # https://bbs.archlinux.org/viewtopic.php?pid=1933643#p1933643
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';

  # TODO: Remove this once landed in kernel.
  # Apply kernel patch for xps 9310 wifi bug.
  # https://patchwork.kernel.org/project/linux-wireless/patch/1605121102-14352-1-git-send-email-kvalo@codeaurora.org/
  boot.kernelPatches = [
    {
      name = "ath11k-qca6390-xps9310";
      patch = builtins.fetchurl "https://patchwork.kernel.org/project/linux-wireless/patch/1605121102-14352-1-git-send-email-kvalo@codeaurora.org/raw/";
    }
  ];

  # Allows for updating firmware via `fwupdmgr`.
  # services.fwupd.enable = true;
}
