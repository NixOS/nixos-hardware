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
  imports = [
    (lib.mkRemovedOptionModule ["hardware" "apple-t2" "enableTinyDfr"] ''
      The hardware.apple-t2.enableTinyDfr option was deprecated and removed since upstream Nixpkgs now has an identical module.
      Please migrate to hardware.apple.touchBar.
    '')
  ];
  options.hardware.apple-t2 = {
    enableAppleSetOsLoader = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable the appleSetOsLoader activation script.";
    };
  };

  config = lib.mkMerge [
    {
      # For keyboard and touchbar
      boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./pkgs/linux-t2.nix { });
      boot.initrd.kernelModules = [ "apple-bce" ];

      services.udev.packages = [ audioFilesUdevRules ];

      # For audio
      boot.kernelParams = [ "pcie_ports=compat" "intel_iommu=on" "iommu=pt" ];

      hardware.pulseaudio.package = overrideAudioFiles pkgs.pulseaudio "src/modules/";

      services.pipewire.package = pipewirePackage;
      services.pipewire.wireplumber.package = pkgs.wireplumber.override {
        pipewire = pipewirePackage;
      };

      # Make sure post-resume.service exists
      powerManagement.enable = true;
    }
    (lib.mkIf t2Cfg.enableAppleSetOsLoader {
      # Activation script to install apple-set-os-loader in order to unlock the iGPU
      system.activationScripts.appleSetOsLoader = ''
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
      environment.etc."modprobe.d/apple-gmux.conf".text = ''
        options apple-gmux force_igd=y
      '';
    })
  ];
}
