{ pkgs, lib, ...}:

{
  imports = [
    ../../../../../lenovo/thinkpad/z/gen2
  ];

  # Fix-Me: The option definition `sound' no longer has any effect; please remove it.
  # sound.extraConfig = ''
  #   pcm.!default {
  #       type plug
  #       slave.pcm "hw:1,0"
  #   }

  #   ctl.!default {
  #       type hw
  #       card 1
  #   }
  # '';
}
