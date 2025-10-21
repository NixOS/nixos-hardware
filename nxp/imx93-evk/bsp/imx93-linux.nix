{ lib, pkgs, ... }@args:
with pkgs;
buildLinux (
  args
  // rec {
    version = "6.12.3";
    name = "imx93-linux";

    # modDirVersion needs to be x.y.z, will automatically add .0 if needed
    modDirVersion = version;

    defconfig = "imx_v8_defconfig";

    # https://github.com/NixOS/nixpkgs/pull/366004
    # introduced a breaking change that if a module is declared but it is not being used it will faill.
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
      # tag: lf-6.12.3
      rev = "37d02f4dcbbe6677dc9f5fc17f386c05d6a7bd7a";
      sha256 = "sha256-1oJMbHR8Ho0zNritEJ+TMOAyYHCW0vwhPkDfLctrZa8=";
    };
    meta = with lib; {
      homepage = "https://github.com/nxp-imx/linux-imx";
      license = [ licenses.gpl2Only ];
      maintainers = with maintainers; [ govindsi ];
      platforms = [ "aarch64-linux" ];
    };
  }
  // (args.argsOverride or { })
)
