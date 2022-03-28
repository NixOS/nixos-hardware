{ pkgs, ... }:

let
  pinnedNixpkgs = import
    (builtins.fetchTarball {
      name = "nixos-unstable-2022-03-28";
      url = "https://github.com/nixos/nixpkgs/archive/ce8cbe3c01fd8ee2de526ccd84bbf9b82397a510.tar.gz";
      sha256 = "19xfad7pxsp6nkrkjhn36w77w92m60ysq7njn711slw74yj6ibxv";
    })
    {
      system = "aarch64-linux";
    };

  patches = [
    # Assorted Manjaro ARM patches
    "1001-arm64-dts-allwinner-add-hdmi-sound-to-pine-devices.patch" # Pine64
    "1002-arm64-dts-allwinner-add-ohci-ehci-to-h5-nanopi.patch" # Nanopi Neo Plus 2
    "1003-drm-bridge-analogix_dp-Add-enable_psr-param.patch" # Pinebook Pro
    "1004-gpu-drm-add-new-display-resolution-2560x1440.patch" # Odroid
    "1005-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch" # Panfrost
    "1006-arm64-dts-rockchip-Add-Firefly-Station-p1-support.patch" # Firelfy Station P1
    "1007-drm-rockchip-add-support-for-modeline-32MHz-e.patch" # DP Alt Mode
    "1008-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay.patch" # RockPro64
    "1010-arm64-dts-amlogic-add-initial-Beelink-GT1-Ultimate-dev.patch" # Beelink
    "1011-arm64-dts-amlogic-add-meson-g12b-ugoos-am6-plus.patch" # Meson Ugoos
    "1012-drm-panfrost-scheduler-improvements.patch" # Panfrost
    "1013-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-RockPr.patch" # RockPro64
    "1014-drm-rockchip-support-gamma-control-on-RK3399.patch" # RK3399 VOP
    "1015-media-rockchip-rga-do-proper-error-checking-in-probe.patch" # Rockchip RGA
    "1016-arm64-dts-rockchip-switch-to-hs200-on-rockpi4.patch" # Radxa Rock Pi 4
    "1017-arm64-dts-meson-remove-CPU-opps-below-1GHz-for-G12B-boards.patch" # AMLogic [1/2]
    "1018-arm64-dts-meson-remove-CPU-opps-below-1GHz-for-SM1-boards.patch" # AMLogic [2/2]
    "1019-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-Rock-P.patch" # Radxa Rock Pi 4

    # Assorted Pinebook, PinePhone and PineTab patches
    "2001-Bluetooth-Add-new-quirk-for-broken-local-ext-features.patch" # Bluetooth
    "2002-Bluetooth-btrtl-add-support-for-the-RTL8723CS.patch" # Bluetooth
    "2003-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook.patch" # Bluetooth
    "2004-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho.patch" # Bluetooth
    "2005-staging-add-rtl8723cs-driver.patch" # Realtek WiFi
    "2006-arm64-dts-allwinner-pinetab-add-accelerometer.patch" # Accelerometer
    "2007-arm64-dts-allwinner-pinetab-enable-jack-detection.patch" # Audio
    "2008-brcmfmac-USB-probing-provides-no-board-type.patch" # Bluetooth
    "2009-dts-rockchip-Adapt-and-adopt-Type-C-support-from-Pin.patch" # DP Alt Mode

    # Pinebook Pro Type-C patches from megous; original patch numbers found
    # on https://xff.cz/kernels/5.17/patches/ are retained, with just the first
    # digit changed from 0 to 3, to make tracking easier
    "3170-arm64-dts-rk3399-pinebook-pro-Fix-USB-PD-charging.patch"
    "3172-arm64-dts-rk3399-pinebook-pro-Improve-Type-C-support.patch"
    "3174-arm64-dts-rk3399-pinebook-pro-Remove-redundant-pinct.patch"
    "3178-arm64-dts-rk3399-pinebook-pro-Don-t-allow-usb2-phy-d.patch"
    "3339-drm-rockchip-cdn-dp-Disable-CDN-DP-on-disconnect.patch"
    "3355-usb-typec-fusb302-Set-the-current-before-enabling-pu.patch"
    "3359-usb-typec-fusb302-Update-VBUS-state-even-if-VBUS-int.patch"
    "3361-usb-typec-fusb302-Add-OF-extcon-support.patch"
    "3362-usb-typec-fusb302-Fix-register-definitions.patch"
    "3363-usb-typec-fusb302-Clear-interrupts-before-we-start-t.patch"
    "3364-usb-typec-typec-extcon-Add-typec-extcon-bridge-drive.patch"
    "3365-phy-rockchip-typec-Make-sure-the-plug-orientation-is.patch"
    "3372-phy-rockchip-inno-usb2-More-robust-charger-detection.patch"
    "3373-usb-typec-extcon-Don-t-touch-charger-proprties.patch"
  ];

  manjaro-patches = pinnedNixpkgs.fetchgit {
    url = "https://gitlab.manjaro.org/manjaro-arm/packages/core/linux.git";
    rev = "d68667dfeb33a40a1ee5d6563ff4815e57ed9084";
    sha256 = "04wb8nx5yw1r044i2cnd1dy4fc7whgn343iid0gqmyg5rk1ack2v";
  };

  create-patch = p: {
    name = p;
    patch = "${manjaro-patches}/${p}";
  };

  manjaro-kernel = pinnedNixpkgs.linuxPackagesFor (pinnedNixpkgs.linuxKernel.kernels.linux_5_16.override {
    argsOverride = rec {
      kernelPatches = map create-patch patches;
      version = "5.16.18";
      modDirVersion = version;
      src = builtins.fetchurl {
        url = "https://www.kernel.org/pub/linux/kernel/v5.x/linux-${version}.tar.xz";
        sha256 = "sha256:096f80m2czj8khvil7s037pqdf1s6pklqn5d9419jqkz7v70piry";
      };
    };
  });
in
{
  inherit manjaro-kernel;
}
