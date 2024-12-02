{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../.
    ../../../common/cpu/intel/kaby-lake
    ../../../common/hidpi.nix
    ../../../common/pc/laptop/ssd
  ];

  # Make the keyboard work in stage1, enable iommu
  # https://www.kernelconfig.io/config_keyboard_applespi

  boot = {
    initrd.kernelModules = ["applespi" "spi_pxa2xx_platform" "intel_lpss_pci" "applesmc" ];
    kernelParams = [ "intel_iommu=on" ];
    kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.0") pkgs.linuxPackages_latest;
  };

  # Touchpad quirks to make "disable-while-typing" actually work
  services.libinput.enable = true;
  environment.etc."libinput/local-overrides.quirks".text = ''
    [MacBook(Pro) SPI Touchpads]
    MatchName=*Apple SPI Touchpad*
    ModelAppleTouchpad=1
    AttrTouchSizeRange=200:150
    AttrPalmSizeThreshold=1100

    [MacBook(Pro) SPI Keyboards]
    MatchName=*Apple SPI Keyboard*
    AttrKeyboardIntegration=internal

    [MacBookPro Touchbar]
    MatchBus=usb
    MatchVendor=0x05AC
    MatchProduct=0x8600
    AttrKeyboardIntegration=internal
  '';

  # Wifi, CPU Microcode FW updates
  networking.enableB43Firmware = lib.mkDefault true;
  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    cpu.intel.updateMicrocode = lib.mkDefault true;
  };

  # [Enable only if needed!]
  # Disable d3cold on older NVME controller, only if needed
  # https://github.com/Dunedan/mbp-2016-linux
  #
  #systemd.services.disable-nvme-d3cold = {
  #  description = "Disables d3cold on the NVME controller";
  #  before      = [ "suspend.target" ];
  #  path        = [ pkgs.bash pkgs.coreutils ];
  #  serviceConfig.Type = "oneshot";
  #  serviceConfig.ExecStart = "${./disable-nvme-d3cold.sh}";
  #  serviceConfig.TimeoutSec = 0;
  #  wantedBy = [ "multi-user.target" "suspend.target" ];
  #};
}
