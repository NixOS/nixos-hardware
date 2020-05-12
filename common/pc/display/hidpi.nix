{ pkgs, lib, ... }: {
  console.font = lib.mkDefault
    "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  # Needed when doing cryptsetup
  console.earlySetup = lib.mkDefault true;
  boot.loader.systemd-boot.consoleMode = lib.mkDefault "max";

  services.xserver.dpi = lib.mkDefault 196;
  fonts.fontconfig.dpi = lib.mkDefault 196;
  environment.variables = lib.mkDefault {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";

  };
}
