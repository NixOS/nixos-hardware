{ config, lib, pkgs, ... }:

let
  audioFiles = pkgs.fetchFromGitHub {
    owner = "kekrby";
    repo = "t2-better-audio";
    rev = "e46839a28963e2f7d364020518b9dac98236bcae";
    hash = "sha256-x7K0qa++P1e1vuCGxnsFxL1d9+nwMtZUJ6Kd9e27TFs=";
  };

  audioFilesUdevRules = pkgs.runCommand "audio-files-udev-rules" {} ''
    mkdir -p $out/lib/udev/rules.d
    cp ${audioFiles}/files/*.rules $out/lib/udev/rules.d
    substituteInPlace $out/lib/udev/rules.d/*.rules --replace "/usr/bin/sed" "${pkgs.gnused}/bin/sed"
  '';

  overrideAudioFiles = package: pluginsPath:
    package.overrideAttrs (new: old: {
      preConfigurePhases = old.preConfigurePhases or [ ] ++ [ "postPatchPhase" ];
      postPatchPhase = ''
        cp -r ${audioFiles}/files/{profile-sets,paths} ${pluginsPath}/alsa/mixer/
      '';
    });

  pipewirePackage = overrideAudioFiles pkgs.pipewire "spa/plugins/";

  tiny-dfrPackage = pkgs.callPackage ./pkgs/tiny-dfr.nix { };

  apple-set-os-loader-installer = pkgs.stdenv.mkDerivation {
    name = "apple-set-os-loader-installer-1.0";
    src = pkgs.fetchFromGitHub {
      owner = "Redecorating";
      repo = "apple_set_os-loader";
      rev = "r33.9856dc4";
      sha256 = "hvwqfoF989PfDRrwU0BMi69nFjPeOmSaD6vR6jIRK2Y=";
    };
    buildInputs = [ pkgs.gnu-efi ];
    buildPhase = ''
      substituteInPlace Makefile --replace "/usr" '$(GNU_EFI)'
      export GNU_EFI=${pkgs.gnu-efi}
      make
    '';
    installPhase = ''
      install -D bootx64_silent.efi $out/bootx64.efi
    '';
  };

  t2Cfg = config.hardware.apple-t2;

in
{
  options = {
    hardware.apple-t2.enableAppleSetOsLoader = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable the appleSetOsLoader activation script.";
    };
  };

  config = {
    # For keyboard and touchbar
    boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./pkgs/linux-t2.nix { });
    boot.initrd.kernelModules = [ "apple-bce" ];

    services.udev.packages = [ audioFilesUdevRules tiny-dfrPackage ];

    # For audio
    boot.kernelParams = [ "pcie_ports=compat" "intel_iommu=on" "iommu=pt" ];

    hardware.pulseaudio.package = overrideAudioFiles pkgs.pulseaudio "src/modules/";

    services.pipewire.package = pipewirePackage;
    services.pipewire.wireplumber.package = pkgs.wireplumber.override {
      pipewire = pipewirePackage;
    };

    # For tiny-dfr
    systemd.services.tiny-dfr = {
      enable = true;
      description = "Tiny Apple silicon touch bar daemon";
      after = [ "systemd-user-sessions.service" "getty@tty1.service" "plymouth-quit.service" "systemd-logind.service" ];
      bindsTo = [ "dev-tiny_dfr_display.device" "dev-tiny_dfr_backlight.device" ];
      startLimitIntervalSec = 30;
      startLimitBurst = 2;
      script = "${tiny-dfrPackage}/bin/tiny-dfr";
      restartTriggers = [ tiny-dfrPackage ];
    };

    environment.etc."tiny-dfr/config.toml" = {
      source = "${tiny-dfrPackage}/share/tiny-dfr/config.toml";
    };

    # Make sure post-resume.service exists
    powerManagement.enable = true;

    # Activation script to install apple-set-os-loader in order to unlock the iGPU
    system.activationScripts.appleSetOsLoader = lib.optionalString t2Cfg.enableAppleSetOsLoader ''
      if [[ -e /boot/efi/efi/boot/bootx64_original.efi ]]; then
        true # It's already installed, no action required
      elif [[ -e /boot/efi/efi/boot/bootx64.efi ]]; then
        # Copy the new bootloader to a temporary location
        cp ${apple-set-os-loader-installer}/bootx64.efi /boot/efi/efi/boot/bootx64_temp.efi

        # Rename the original bootloader
        mv /boot/efi/efi/boot/bootx64.efi /boot/efi/efi/boot/bootx64_original.efi

        # Move the new bootloader to the final destination
        mv /boot/efi/efi/boot/bootx64_temp.efi /boot/efi/efi/boot/bootx64.efi
      else
        echo "Error: /boot/efi/efi/boot/bootx64.efi is missing" >&2
      fi
    '';

    # Enable the iGPU by default if present
    environment.etc."modprobe.d/apple-gmux.conf".text = lib.optionalString t2Cfg.enableAppleSetOsLoader ''
      options apple-gmux force_igd=y
    '';
  };
}
