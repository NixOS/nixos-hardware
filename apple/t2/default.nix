{ pkgs, ... }:

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
in
{
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

  services.pipewire = rec {
    package = overrideAudioFiles pkgs.pipewire "spa/plugins/";

    wireplumber.package = pkgs.wireplumber.override {
      pipewire = package;
    };
  };

  # Make sure post-resume.service exists
  powerManagement.enable = true;

  systemd.services.fix-keyboard-backlight-and-touchbar = {
    path = [ pkgs.kmod ];
    serviceConfig.ExecStart = ''${pkgs.systemd}/bin/systemd-inhibit --what=sleep --why="fixing keyboard backlight and touchbar must finish before sleep" --mode=delay ${./fix-keyboard-backlight-and-touchbar.sh}'';
    serviceConfig.Type = "oneshot";
    description = "reload touchbar driver and restart upower";
    # must run at boot (and not too early), and after suspend
    wantedBy = [ "display-manager.service" "post-resume.target" ];
    # prevent running before suspend
    after = [ "post-resume.target" ];
  };
}
