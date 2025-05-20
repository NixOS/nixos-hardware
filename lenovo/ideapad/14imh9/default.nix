{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel/meteor-lake
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  boot = {
    # Workaround: Out of the box, resuming from hibernation will break sounds.
    #             See https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/issues/766
    extraModprobeConfig = ''
      options snd-hda-intel model=generic
      options snd-hda-intel snd-intel-dspcfg.dsp_driver=1
      blacklist snd_soc_skl
    '';

    kernelParams = [
      # Workaround: i915 0000:00:02.0: [drm] *ERROR* Atomic update failure on pipe A
      #             See https://www.dedoimedo.com/computers/intel-microcode-atomic-update.html
      "i915.enable_psr=0"

      # Workaround: Seems like guc on VT-d is faulty and may also cause GUC: TLB invalidation response timed out.
      #             It will cause random gpu resets under hw video decoding.
      #             See https://wiki.archlinux.org/title/Dell_XPS_16_(9640)#Random_freezes
      "iommu.strict=1"
      "iommu.passthrough=1"
    ];
  };

  environment.variables = {
    # Workaround: GPU HANG: ecode 12:1:85dffdfb, in CanvasRenderer [4408]
    #             See https://gitlab.freedesktop.org/mesa/mesa/-/issues/7755
    INTEL_DEBUG = "no32";
  };

  systemd = {
    # Workaround: Sometimes xhci driver will become malfunctional after resuming from hibernate / suspend.
    #             This will cause (almost) all external devices stop working.
    #             A simple reset is enough to bring external devices alive :)
    #
    #             Note: to avoid unnecessary resets, we firstly check if integrated camera is presented
    #                   (Should always be there as it was built into machine!).
    #                   If not, just do the reset.
    services.workaround-reset-xhci-driver-after-resume-if-needed = {
      script = ''
        result=$(${pkgs.usbutils}/bin/lsusb | ${pkgs.gnugrep}/bin/grep Chicony)
        if [[ -z $result ]]; then
          ${pkgs.kmod}/bin/rmmod xhci_pci xhci_hcd
          ${pkgs.kmod}/bin/modprobe xhci_pci xhci_hcd
        fi
      '';
      after = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
      ];
      wantedBy = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "multi-user.target"
      ];
    };

    # Workaround: Lenovo seems write bad acpi power management firmware. Without this config,
    #             suspend (to ram / disk) will simply reboot instead of power off. :(
    sleep.extraConfig = ''
      HibernateMode=shutdown
    '';
  };

  # TPM2 module
  security.tpm2.enable = lib.mkDefault true;

  hardware = {
    enableRedistributableFirmware = lib.mkDefault true; # WiFi

    # Workaround: Lenovo wrote bad screen edid firmware that will cause system
    #             not able to use 120Hz screen fresh rate.
    #             Manually patch it with correct value fixes this problem.
    #
    #             TODO: This laptop actually support VRR (Variable refresh rate).
    #                   But I do not have any interests in supporting this.
    #                   PR is welecomed :)
    display = {
      edid.packages = [
        (pkgs.runCommand "edid-14imh9" { } ''
          mkdir -p "$out/lib/firmware/edid"
          base64 -d > "$out/lib/firmware/edid/14imh9.bin" <<'EOF'
          AP///////wAObxYUAAAAAAAgAQS1HhN4AyEVqFNJnCUPUFQAAAABAQEBAQEBAQEBAQEBAQEBzodAoLAIanAwIDYALbwQAAAYAAAA/QAoeOXlRgEKICAgICAgAAAA/gBDU09UIFQzCiAgICAgAAAA/gBNTkUwMDdaQTEtNQogAa9wE3kAAAMBFJoPAQU/C58ALwAfAAcHaQACAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD4kA==
          EOF
        '')
      ];

      outputs = {
        "eDP-1".edid = "14imh9.bin";
      };
    };

    i2c.enable = lib.mkDefault true; # Touchpad
  };

  services = {
    fwupd.enable = lib.mkDefault true; # Firmware Upgrades. Partially supported.
    hardware.bolt.enable = lib.mkDefault true; # Thunderbolt
    thermald.enable = lib.mkDefault true; # This will save you money and possibly your life!
  };
}
