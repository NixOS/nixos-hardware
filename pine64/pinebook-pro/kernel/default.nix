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
    };
  });
in
{
  inherit unstable-manjaro-kernel;
}
