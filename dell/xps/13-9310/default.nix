{ lib, pkgs, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
  ];

  # TODO: upstream to NixOS/nixpkgs
  nixpkgs.overlays = [(final: previous: {
    qca6390-firmware = final.callPackage ./qca6390-firmware.nix {};
  })];

  hardware.firmware = lib.mkBefore [
    # Firmware for the AX500 (wi-fi & bluetooth chip).
    pkgs.qca6390-firmware
  ];

  # Confirmed necessary to get audio working as of 2020-11-13:
  # https://bbs.archlinux.org/viewtopic.php?pid=1933643#p1933643
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';

  # Touchpad goes over i2c.
  # Without this we get errors in dmesg on boot and hangs when shutting down.
  boot.blacklistedKernelModules = [ "psmouse" ];

  # TODO: Remove this once landed in kernel.
  # Apply kernel patch for xps 9310 wifi bug.
  # https://patchwork.kernel.org/project/linux-wireless/patch/1605121102-14352-1-git-send-email-kvalo@codeaurora.org/
  boot.kernelPatches = [
    # kvalo qca6390 patches
    # https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/log/?h=ath11k-qca6390-bringup
    {
      name = "add-64-bit-check-before-reading-msi-high-addr";
      patch = builtins.fetchurl "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=065c9528cc508cfbf6e3399582df29f76f56163c";
    }
    {
      name = "pci-support-platforms-with-one-msi-vector";
      patch = builtins.fetchurl "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=59c6d022df8efb450f82d33dd6a6812935bd022f";
    }
    {
      name = "try-to-allocate-big-block-of-dma-memory-firstly";
      patch = builtins.fetchurl "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=0d8b0aff6b77ea5a8d715ba5d0089f9dffbabf21";
    }
    {
      name = "fix-monitor-status-dma-unmap-direction";
      patch = builtins.fetchurl "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=fa4eea695afb286ae38beb30dabf251335cb4a62";
    }
    {
      name = "hook-mhi-suspend-and-resume";
      patch = builtins.fetchurl "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=762fe5bc2dd1e43ef307a375861b1a8c414b14e3";
    }
    {
      name = "implement-hif-suspend-and-resume-functions";
      patch = builtins.fetchurl "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=2f164833bcca14e8aec0b2566eae4b5a7d09ee6f";
    }
    {
      name = "read-select_window-register-to-ensure-write-is-finished";
      patch = builtins.fetchurl "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=6afab932ece78fedc1538c20c2aefdd13aa6c9d0";
    }
    {
      name = "implement-htc-suspend-related-callbacks";
      patch = builtins.fetchurl "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=69ab2835b82c176e793195243e1400d4f8db3647";
    }
    {
      name = "put-target-to-suspend-when-system-enters-suspend-state";
      patch = builtins.fetchurl "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=68023bee4d61ea2b02af49bba00adabba51d8b6b";
    }
    {
      name = "pci-print-a-warning-if-firmware-crashed";
      patch = builtins.fetchurl "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=23dcef9436560a033703164c4daff9e36e640969";
    }
    {
      name = "qmi-print-allocated-memory-segment-addresses-and-sizes";
      patch = builtins.fetchurl "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=a327caa4a5a677161a6f1d29514e8cb42236e956";
    }
    {
      name = "hack-add-delays-to-suspend-and-resume-handlers";
      patch = builtins.fetchurl "https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/patch/?id=a9ce8040a968bdbb5aad2d767298d390e2507b16";
    }
  ];

  # Allows for updating firmware via `fwupdmgr`.
  # services.fwupd.enable = true;
}
