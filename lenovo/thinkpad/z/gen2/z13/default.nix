{ pkgs, lib, ...}:

{
  imports = [
    ../../../../../lenovo/thinkpad/z/gen2
  ];

  environment.etc."asound.conf".source = ./asound.conf;
}
