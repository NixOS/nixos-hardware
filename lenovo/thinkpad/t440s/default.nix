{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
  ];

  boot = {
    # TODO: probably enable tcsd? Is this line necessary?
    kernelModules = [ "tpm-rng" ];
  };
}
