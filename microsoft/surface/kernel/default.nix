{ config, lib, pkgs, ... }:

{
  boot.kernelPackages = pkgs.callPackage ./linux-5.13.4 { };
}
