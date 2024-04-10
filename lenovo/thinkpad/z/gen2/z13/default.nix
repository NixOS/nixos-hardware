{ pkgs, lib, ...}:

{
  imports = [
    ../../../../../lenovo/thinkpad/z/gen2
  ];

  sound.extraConfig = ''
    pcm.!default {
        type plug
        slave.pcm "hw:1,0"
    }

    ctl.!default {
        type hw
        card 1
    }
  '';
}
