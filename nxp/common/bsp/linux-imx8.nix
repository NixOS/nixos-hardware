{ pkgs, ... }@args:

with pkgs;

buildLinux (
  args
  // rec {
    version = "5.15.71";

    # modDirVersion needs to be x.y.z, will automatically add .0 if needed
    modDirVersion = version;

    defconfig = "imx_v8_defconfig";

    # https://github.com/NixOS/nixpkgs/pull/366004
    # introduced a breaking change that if a module is declared but it is not being used it will fail.
    ignoreConfigErrors = true;

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
      # tag: refs/tags/lf-5.15.71-2.2.0
      rev = "3313732e9984cb8a6b10a9085c7e18d58e770d56";
      sha256 = "sha256-PBRiSgjPOq4keiwPOfNOswf1Zzdbn6YOjpOgv4/Oscc=";
    };
  }
  // (args.argsOverride or { })
)
