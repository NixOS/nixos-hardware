{
  lib,
  buildLinux,
  fetchFromGitHub,
  ...
}@args:
buildLinux (
  args
  // rec {
    version = "6.6.36";
    name = "imx95-linux";

    # modDirVersion needs to be x.y.z, will automatically add .0 if needed
    modDirVersion = version;

    defconfig = "compulab-mx95_defconfig";

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
      owner = "compulab-yokneam";
      repo = "linux-compulab";
      # tag: linux-compulab_6.6.36
      rev = "b93daaad0807fb15d4f3f1a6e5be843ac7532ef7";
      sha256 = "sha256-wCeuGXBTz3H6OFWBA1M1/t/9WgxBVjQ8FU/wvAUVW2w=";
    };
    meta = with lib; {
      homepage = "https://github.com/compulab-yokneam/linux-compulab";
      license = licenses.gpl2Only;
      maintainers = [
        {
          name = "Govind Singh";
          email = "govind.singh@tii.ae";
        }
      ];
      platforms = [ "aarch64-linux" ];
    };
  }
  // (args.argsOverride or { })
)
