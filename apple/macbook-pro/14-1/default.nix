{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../../common/cpu/intel/kaby-lake
    ../../../common/gpu/intel
    ../../../common/hidpi.nix
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ../../../common/pc/laptop/acpi_call.nix
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

  # Bluetooth, only needed if kernel lacks support - custom kernel build
  # boot.kernelPatches = [
  #  {
  #    name = "bcrm-config";
  #    patch = null;
  #    extraConfig = ''
  #      BT_HCIUART_BCM y '';
  #  }
  # ];
  
  ##  [Workaround seems not to work anymore! Any Ideas?]
  # For some reason /dev/ttyS0 is created, and then removed by udev. We need this
  # for bluetooth, and the only way to get it again is to reload 8502_dw. Luckily,
  # nothing else uses it.
  ## 
  # systemd.services.btattach-bcm2e7c = lib.mkIf config.hardware.bluetooth.enable {
  #  before = [ "bluetooth.target" ];
  #  after = [ "sys-devices-platform-serial8250-tty-ttyS1.device" ];
  #  path = [ pkgs.bash pkgs.kmod pkgs.bluez ];
  #  serviceConfig.Type = "simple";
  #  serviceConfig.ExecStart = "${./btfix.sh}";
  #  wantedBy = [ "multi-user.target" ];
  # };

  ## [Enable only if needed!]
  # Disable d3cold on older NVME controller, only if needed
  # https://github.com/Dunedan/mbp-2016-linux
  ##
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
