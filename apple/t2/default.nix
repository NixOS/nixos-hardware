{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) types;

  t2bce-alsa-ucm = pkgs.stdenvNoCC.mkDerivation (_: {
    name = "t2bce-alsa-ucm";
    src = pkgs.fetchFromGitHub {
      owner = "deqrocks";
      repo = "t2bce";
      rev = "967465dc67d3a9b1e48dea620f7258baa526f4f2";
      hash = "sha256-EVUvNg30bFhJCtcyPAGbWjGX0+CORs4nWG5Bpvbr590=";
    };

    meta = {
      description = "ALSA Usage Configuration Manager configuration for T2 Macs";
      license = lib.licenses.mit;
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      cd ./t2bce_audio-alsa-ucm-conf
      mkdir -p "$out/share/alsa/"
      cp -vR ./ucm2 "$out/share/alsa/"

      runHook postInstall
    '';
  });

  patched-alsa-ucm = pkgs.symlinkJoin {
    inherit (t2bce-alsa-ucm) src meta;
    name = "t2bce-alsa-ucm-patched";
    paths = [
      pkgs.alsa-ucm-conf
      t2bce-alsa-ucm
    ];
  };

  patchedAudioAlsaEnv = lib.genAttrs [ "pipewire" "wireplumber" "pulseaudio" ] (_: {
    environment.ALSA_CONFIG_UCM2 = config.environment.variables.ALSA_CONFIG_UCM2;
  });

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
    firmware = {
      enable = lib.mkEnableOption "automatic and declarative Wi-Fi and Bluetooth firmware configuration";
      version = lib.mkOption {
        type = types.enum [
          "monterey"
          "ventura"
          "sonoma"
        ];
        default = "sonoma";
        example = "ventura";
        description = "The macOS version to use.";
      };
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
      boot.initrd.kernelModules = [ "t2bce-vhci" ];

      # For audio and suspend
      boot.kernelParams = [
        "intel_iommu=on"
        "iommu=pt"
        "pm_async=off"
      ];

      # audio configuration
      # https://github.com/nix-community/nixos-apple-silicon/blob/66d8dd2c27f99bd5420c99938b60695aac1785c4/apple-silicon-support/modules/sound/default.nix#L46
      environment.variables.ALSA_CONFIG_UCM2 = "${patched-alsa-ucm}/share/alsa/ucm2";
      # setting systemd.globalEnvironment is likely going to have unexpected side effects
      systemd = {
        services = patchedAudioAlsaEnv;
        user.services = patchedAudioAlsaEnv;
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
    (lib.mkIf t2Cfg.firmware.enable {
      # Configure Wi-Fi and Bluetooth firmware
      hardware.firmware = [
        (pkgs.callPackage ./pkgs/brcm-firmware { version = t2Cfg.firmware.version; })
      ];
    })
  ];
}
