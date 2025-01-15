{ config, lib, ... }:
{
    imports = [
        ../../../common/cpu/intel
        ../../../common/gpu/nvidia # Is it possible/advisable to pin this to the 390.xx driver family in case the user wants to use non-free drivers?
        ../../../common/gpu/amd # The K330 could be bought with AMD GPUs but I don't have that configuration
        ../../../common/pc
    ];

    # On my machine Wayland causes the desktop to freeze after a short time of operation
    services.displayManager.sddm.wayland.enable = false;

    # Should this be a conditional default in case plasma is activated?
    # What if somebody installs both plasma AND another DE?
    # The goal is to prefer x11 over wayland due to compatibility issues with the old hardware

    
    services.displayManager.defaultSession = lib.mkIf config.services.xserver.desktopManager.plasma6.enable (lib.mkDefault "plasmax11");
}