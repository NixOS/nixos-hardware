{pkgs, ...} @ args:
with pkgs;
  buildLinux (args
    // rec {
      version = "6.1.55";
      name = "imx8mp-linux";

      # modDirVersion needs to be x.y.z, will automatically add .0 if needed
      modDirVersion = version;

      defconfig = "imx_v8_defconfig";

      kernelPatches = [
      ];

      autoModules = false;

      extraConfig = ''
        CRYPTO_TLS m
        TLS y
        MD_RAID0 m
        MD_RAID1 m
        MD_RAID10 m
        MD_RAID456 m
        DM_VERITY m
        LOGO y
        FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER n
        FB_EFI n
        EFI_STUB y
        EFI y
        VIRTIO y
        VIRTIO_PCI y
        VIRTIO_BLK y
        DRM_VIRTIO_GPU y
        EXT4_FS y
        USBIP_CORE m
        USBIP_VHCI_HCD m
        USBIP_HOST m
        USBIP_VUDC m
      '';

      src = fetchFromGitHub {
        owner = "nxp-imx";
        repo = "linux-imx";
        # tag: lf-6.1.55-2.2.0
        rev = "770c5fe2c1d1529fae21b7043911cd50c6cf087e";
        sha256 = "sha256-tIWt75RUrjB6KmUuAYBVyAC1dmVGSUAgqV5ROJh3xU0=";
      };
    }
    // (args.argsOverride or {}))
