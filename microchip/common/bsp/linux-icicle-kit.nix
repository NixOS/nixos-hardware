{ pkgs, ... } @ args:

with pkgs;

buildLinux (args // rec {
  version = "6.1.43-linux4microchip+fpga-2023.09";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = version;

  defconfig = "mpfs_defconfig";

  kernelPatches = [
  ];

  autoModules = false;

  extraConfig = ''
    OF_OVERLAY y
    OF_CONFIGFS y
    MFD_SENSEHAT_CORE m
    INPUT_JOYDEV m
    INPUT_JOYSTICK y
    JOYSTICK_SENSEHAT m
    AUXDISPLAY y
    SENSEHAT_DISPLAY m
    HTS221 m
    IIO_ST_PRESS m
    IIO_ST_LSM6DSX m
    IIO_ST_MAGN_3AXIS m
    POLARFIRE_SOC_DMA_NONCOHERENT y
    MTD_SPI_NOR_USE_4K_SECTORS n
    MTD_UBI y
    MTD_CMDLINE_PARTS y
    UBIFS_FS y
    USB_UAS m
    CRYPTO_TLS m
    TLS y
    MD y
    BLK_DEV_MD m
    MD_AUTODETECT y
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
    owner = "linux4microchip";
    repo = "linux";
    rev = "25e35c7c54ad853d03c14a02b189b408cb5b5eb3";
    sha256 = "sha256-wj7lz247MkhxmhSHUcNeWmcZK+DL+5PAnLwTmALD97M=";
  };
} // (args.argsOverride or { }))
