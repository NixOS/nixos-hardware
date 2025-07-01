{
  lib,
  buildLinux,
  fetchFromGitHub,
  kernelPatches ? [ ],
  structuredExtraConfig ? { },
  extraMeta ? { },
  argsOverride ? { },
  ...
}@args:

let
  version = "6.1.43-linux4microchip+fpga-2023.09";
in
buildLinux (
  args
  // {
    inherit version kernelPatches extraMeta;

    # modDirVersion needs to be x.y.z, will automatically add .0 if needed
    modDirVersion = version;

    defconfig = "mpfs_defconfig";

    autoModules = false;

    structuredExtraConfig =
      with lib.kernel;
      {
        OF_OVERLAY = yes;
        OF_CONFIGFS = yes;
        MFD_SENSEHAT_CORE = module;
        INPUT_JOYDEV = module;
        INPUT_JOYSTICK = yes;
        JOYSTICK_SENSEHAT = module;
        AUXDISPLAY = yes;
        SENSEHAT_DISPLAY = module;
        HTS221 = module;
        IIO_ST_PRESS = module;
        IIO_ST_LSM6DSX = module;
        IIO_ST_MAGN_3AXIS = module;
        POLARFIRE_SOC_DMA_NONCOHERENT = yes;
        MTD_SPI_NOR_USE_4K_SECTORS = no;
        MTD_UBI = yes;
        MTD_CMDLINE_PARTS = yes;
        UBIFS_FS = yes;
        USB_UAS = module;
        EFI_STUB = yes;
        EFI = yes;
        USBIP_CORE = module;
        USBIP_VHCI_HCD = module;
        USBIP_HOST = module;
        USBIP_VUDC = module;
        CRYPTO_TLS = module;
        MD = yes;
        BLK_DEV_MD = module;
        MD_LINEAR = module;
        MD_RAID0 = module;
        MD_RAID1 = module;
        MD_RAID10 = module;
        MD_RAID456 = module;

        # This device doesn't have any kind of display output at all
        FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER = lib.mkForce no;
        FB_EFI = lib.mkForce no;
      }
      // structuredExtraConfig;

    src = fetchFromGitHub {
      owner = "linux4microchip";
      repo = "linux";
      rev = "25e35c7c54ad853d03c14a02b189b408cb5b5eb3";
      sha256 = "sha256-wj7lz247MkhxmhSHUcNeWmcZK+DL+5PAnLwTmALD97M=";
    };
  }
  // argsOverride
)
