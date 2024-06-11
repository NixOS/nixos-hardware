{ ... }: {
  imports = [
    ../../common/cpu/intel
    ../../common/pc/laptop
    ../../common/pc/laptop/ssd
    ../../common/hidpi.nix
  ];
  # Fixes the display being rotated 90 degrees.
  boot.kernelParams =
    [ "fbcon=rotate:1" "video=DSI-1:panel_orientation=right_side_up" ];
}
