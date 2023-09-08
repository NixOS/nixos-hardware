{ config, lib, pkgs, ... }:

let
  audioFiles = pkgs.fetchFromGitHub {
    owner = "kekrby";
    repo = "t2-better-audio";
    rev = "e46839a28963e2f7d364020518b9dac98236bcae";
    hash = "sha256-x7K0qa++P1e1vuCGxnsFxL1d9+nwMtZUJ6Kd9e27TFs=";
  };

  overrideAudioFiles = package: pluginsPath:
    package.overrideAttrs (new: old: {
      preConfigurePhases = old.preConfigurePhases or [ ] ++ [ "postPatchPhase" ];
      postPatchPhase = ''
        cp -r ${audioFiles}/files/{profile-sets,paths} ${pluginsPath}/alsa/mixer/
      '';
    });

  pipewirePackage = overrideAudioFiles pkgs.pipewire "spa/plugins/";

  apple-set-os-loader-installer = pkgs.stdenv.mkDerivation rec {
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

  t2Cfg = config.appleT2Config;

in
{
  options = {
    appleT2Config.enableAppleSetOsLoader = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable the appleSetOsLoader activation script.";
    };
  };

  config = {
    # For keyboard and touchbar
    boot.kernelPackages = with pkgs; recurseIntoAttrs (linuxPackagesFor (callPackage ./pkgs/linux-t2.nix { }));
    boot.initrd.kernelModules = [ "apple-bce" ];

    # For audio
    boot.kernelParams = [ "pcie_ports=compat" "intel_iommu=on" "iommu=pt" ];
    services.udev.extraRules = builtins.readFile (pkgs.substitute {
      src = "${audioFiles}/files/91-audio-custom.rules";
      replacements = [ "--replace" "/usr/bin/sed" "${pkgs.gnused}/bin/sed" ];
    });

    hardware.pulseaudio.package = overrideAudioFiles pkgs.pulseaudio "src/modules/";

    services.pipewire.package = pipewirePackage;
    services.pipewire.wireplumber.package = pkgs.wireplumber.override {
      pipewire = pipewirePackage;
    };

    # Make sure post-resume.service exists
    powerManagement.enable = true;

    systemd.services.fix-keyboard-backlight-and-touchbar = {
      path = [ pkgs.kmod ];
      serviceConfig.ExecStart = ''${pkgs.systemd}/bin/systemd-inhibit --what=sleep --why="fixing keyboard backlight and touchbar must finish before sleep" --mode=delay ${./fix-keyboard-backlight-and-touchbar.sh}'';
      serviceConfig.Type = "oneshot";
      description = "reload touchbar driver and restart upower";
      wantedBy = [ "display-manager.service" "post-resume.target" ];
      after = [ "post-resume.target" ];
    };

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
  };
}
