{ lib, buildLinux, fetchurl, fetchgit, linux_5_7, kernelPatches, ... }@args:

let
  linux = linux_5_7;
  systemImageSrc = fetchgit {
    url = "https://source.mnt.re/reform/reform-system-image.git";
    rev = "ef6bae4def9ef08ee388254abf4f1839d44c07a1";
    sha256 = "03nnwjzm8a0bk821p6sfscd04x3jgj29l16ccdkg10xcv2g2z5s8";
  } + "/reform2-imx8mq";
in lib.overrideDerivation (buildLinux (args // {
  inherit (linux) src version;

  features = {
    efiBootStub = false;
    iwlwifi = false;
  } // (args.features or { });

  kernelPatches = let
    patchDir = "${systemImageSrc}/template-kernel/patches";
    reformPatches = map ({ name, extraConfig ? "" }: {
      inherit name extraConfig;
      patch = "${patchDir}/${name}.patch";
    }) [
      {
        name = "0001-drm-bridge-Add-NWL-MIPI-DSI-host-controller-support";
        extraConfig = ''
          DRM_NWL_MIPI_DSI m
        '';
      }
      { name = "0002-dt-bindings-display-bridge-Add-binding-for-NWL-mipi-"; }
      {
        name =
          "0003-DCSS-v4-Add-support-for-iMX8MQ-Display-Controller-Subsystem";
        extraConfig = ''
          DRM_IMX_DCSS m
        '';
      }
      { name = "4101-media-vb2-wait-for-dmabuf-fences"; }
      { name = "4201-HACK-media-vb2-don-t-validate-buffer-length"; }
      { name = "44f0bbdcf0433052b4e85940cb41d04c13fdad57"; }
      { name = "git.linuxtv.org-28a202c55963386b8bc45bcc52029362e9aa0d33"; }
      { name = "git.linuxtv.org-88d06362d1d052e4c844ac95a2ca308ed4d90452"; }
      { name = "mnt1000-pcie-reparent-clocks"; }
      { name = "mnt1001-pcie-support-internal-refclk-aspm"; }
      { name = "mnt2000-audio-wm8960-add-dacslope-setting"; }
      { name = "mnt2001-audio-sai-workaround-rate-matching"; }
      { name = "mnt3000-imx-dcss-tweak-DCSS-pixel-rate-to-prevent-sporadic-d"; }
      { name = "mnt3001-nwl-dsi-disable-bridge_mode_fixup-that-breaks-hs-vs-"; }
      { name = "mnt3002-MNT-Reform2-add-simple-panel-Innolux-N125HCE-GN1"; }
      {
        name = "mnt3003-MNT-Reform-import-cadence-HDMI-driver-for-imx8mq-fro";
        extraConfig = ''
          DRM_CDNS_AUDIO m
          DRM_CDNS_DP m
          DRM_CDNS_HDMI m
          DRM_CDNS_HDMI_CEC m
          DRM_CDNS_MHDP m
        '';
      }
      { name = "mnt3004-MNT-Reform-imx8mq-add-PHY_27M-clock"; }
      { name = "mnt3005-MNT-Reform-imx8mq-DCSS-add-module-option-to-toggle-h"; }
      { name = "mnt3006-MNT-Reform-imx8mq-add-PHY_27M-clock-missing-define"; }
      {
        name = "mnt3007-MNT-Reform-imx8mq-missing-kconf-makefile-for-cadence";
        extraConfig = ''
          DRM_IMX_CDNS_MHDP m
          DRM_IMX_DCSS m
        '';
      }
      {
        name = "mnt3008-MNT-Reform-imx8mq-missing-makefile-change-for-imx-dc";
        extraConfig = ''
          DRM_IMX_DCSS m
        '';
      }
    ];
  in lib.lists.unique (kernelPatches ++ reformPatches ++ [{
    name = "MNT-Reform-imx8mq-config";
    patch = null;
    extraConfig = fetchurl {
      url =
        "https://github.com/NixOS/nixos-hardware/releases/download/mnt-reform2-nitrogen8m-v1/kernel-config";
      sha256 = "1brazbr9zflb29i4fjhwn1z87bg475lqvzkksvi5n775zx28fk65";
    };
  }]);

  allowImportFromDerivation = true;

} // (args.argsOverride or { }))) (attrs: {
  prePatch = attrs.prePatch + ''
    cp ${systemImageSrc}/template-kernel/*.dts arch/arm64/boot/dts/freescale/
    cp ${systemImageSrc}/template-kernel/*.dtsi arch/arm64/boot/dts/freescale/
    echo 'dtb-$(CONFIG_ARCH_MXC) += imx8mq-mnt-reform2.dtb' >> \
      arch/arm64/boot/dts/freescale/Makefile
  '';
  makeFlags = attrs.makeFlags ++ [ "LOADADDR=0x40480000" ];
})
