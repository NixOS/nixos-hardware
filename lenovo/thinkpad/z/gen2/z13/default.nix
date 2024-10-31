{ pkgs, lib, ...}:

{
  imports = [
    ../../../../../lenovo/thinkpad/z/gen2
  ];

  environment.etc."asound.conf".source = ./asound.conf;

  networking.networkmanager.fccUnlockScripts = [
    {
      id = "2c7c:030a";
      path = "${pkgs.modemmanager}/share/ModemManager/fcc-unlock.available.d/2c7c:030a";
    }
  ];
}
