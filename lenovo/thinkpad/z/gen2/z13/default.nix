{ pkgs, ... }:

{
  imports = [
    ../../../../../lenovo/thinkpad/z/gen2
  ];

  environment.etc."asound.conf".source = ./asound.conf;

  networking =
    let
      fcc_unlock_script = rec {
        id = "2c7c:030a";
        path = "${pkgs.modemmanager}/share/ModemManager/fcc-unlock.available.d/${id}";
      };
    in
    {
      modemmanager.fccUnlockScripts = [ fcc_unlock_script ];
    };
}
