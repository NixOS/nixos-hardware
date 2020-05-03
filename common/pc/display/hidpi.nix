# Shared configuration which most (if not all) HiDPI setups should have.
{ config, lib, pkgs, ... }:

{
  services.xserver.dpi = lib.mkDefault 196;
  fonts.fontconfig.dpi = lib.mkDefault 196;

  # Fix sizes of GTK/GNOME ui elements
  environment.variables = {
    GDK_SCALE = lib.mkDefault "2";
    GDK_DPI_SCALE= lib.mkDefault "0.5";
  };
}
