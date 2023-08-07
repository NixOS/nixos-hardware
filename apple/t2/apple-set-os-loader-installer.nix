{ config, pkgs, ... }:
let
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
in
{
  system.activationScripts.hybrid-graphics = {
    text = ''
      if [[ -e /boot/efi/EFI/BOOT/bootx64_original.efi ]]; then
        # We interpret this as apple-set-os-loader being already installed
        exit 0
      elif [[ -e /boot/efi/EFI/BOOT/BOOTX64.EFI ]] then
        mv /boot/efi/EFI/BOOT/BOOTX64.EFI  /boot/efi/EFI/BOOT/bootx64_original.efi
        cp ${apple-set-os-loader-installer}/bootx64.efi /boot/efi/EFI/BOOT/bootx64.efi
      else
        echo "Error: /boot/efi/EFI/BOOT/BOOTX64.EFI is missing"
      fi
    '';
  };
  environment.etc."modprobe.d/apple-gmux.conf".text = ''
    # Enable the iGPU by default if present
    options apple-gmux force_igd=y
  '';
  environment.systemPackages = with pkgs; [ apple-set-os-loader-installer ];
}
