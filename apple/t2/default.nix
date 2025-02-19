{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) types;
  audioFiles = pkgs.fetchFromGitHub {
    owner = "kekrby";
    repo = "t2-better-audio";
    rev = "e46839a28963e2f7d364020518b9dac98236bcae";
    hash = "sha256-x7K0qa++P1e1vuCGxnsFxL1d9+nwMtZUJ6Kd9e27TFs=";
  };

  audioFilesUdevRules = pkgs.runCommand "audio-files-udev-rules" { } ''
    mkdir -p $out/lib/udev/rules.d
    cp ${audioFiles}/files/*.rules $out/lib/udev/rules.d
    substituteInPlace $out/lib/udev/rules.d/*.rules --replace "/usr/bin/sed" "${pkgs.gnused}/bin/sed"
  '';

  overrideAudioFiles =
    package: pluginsPath:
    package.overrideAttrs (
      new: old: {
        preConfigurePhases = old.preConfigurePhases or [ ] ++ [ "postPatchPhase" ];
        postPatchPhase = ''
          cp -r ${audioFiles}/files/{profile-sets,paths} ${pluginsPath}/alsa/mixer/
        '';
      }
    );

  pipewirePackage = overrideAudioFiles pkgs.pipewire "spa/plugins/";

  t2Cfg = config.hardware.apple-t2;

in
{
  imports = [
    (lib.mkRemovedOptionModule [ "hardware" "apple-t2" "enableTinyDfr" ] ''
      The hardware.apple-t2.enableTinyDfr option was deprecated and removed since upstream Nixpkgs now has an identical module.
      Please migrate to hardware.apple.touchBar.
    '')

    (lib.mkRemovedOptionModule [ "hardware" "apple-t2" "enableAppleSetOsLoader" ] ''
      The hardware.apple-t2.enableAppleSetOsLoader option was removed as the apple_set_os functionality was integrated into the kernel.
      Please uninstall the loader by replacing /esp/EFI/BOOTX64.EFI with /esp/EFI/BOOTX64_original.EFI, where esp is the EFI partition mount point.

      If you have a device with an AMD dGPU and would like to keep using the iGPU, please set hardware.apple-t2.enableIGPU to true.
    '')
  ];
  options.hardware.apple-t2 = {
    enableIGPU = lib.mkEnableOption "the usage of the iGPU on specific Apple devices with an AMD dGPU";
    kernelChannel = lib.mkOption {
      type = types.enum [
        "stable"
        "latest"
      ];
      default = "stable";
      example = "latest";
      description = "The kernel release stream to use.";
    };
  };

  config = lib.mkMerge [
    {
      # Specialized kernel for keyboard, touchpad, touchbar and audio.
      boot.kernelPackages = pkgs.linuxPackagesFor (
        pkgs.callPackage (
          if t2Cfg.kernelChannel == "stable" then ./pkgs/linux-t2 else ./pkgs/linux-t2/latest.nix
        ) { }
      );
      boot.initrd.kernelModules = [ "apple-bce" ];

      services.udev.packages = [ audioFilesUdevRules ];

      # For audio
      boot.kernelParams = [
        "pcie_ports=compat"
        "intel_iommu=on"
        "iommu=pt"
      ];

      hardware.pulseaudio.package = overrideAudioFiles pkgs.pulseaudio "src/modules/";

      services.pipewire.package = pipewirePackage;
      services.pipewire.wireplumber.package = pkgs.wireplumber.override {
        pipewire = pipewirePackage;
      };

      # Make sure post-resume.service exists
      powerManagement.enable = true;
    }
    (lib.mkIf t2Cfg.enableIGPU {
      # Enable the iGPU by default if present
      environment.etc."modprobe.d/apple-gmux.conf".text = ''
        options apple-gmux force_igd=y
      '';
    })
  ];
}
