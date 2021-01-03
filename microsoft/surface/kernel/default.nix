{ config, lib, pkgs, ... }:

{
  # TODO: Create a function for selecting preferred kernel:
  boot.kernelPackages = pkgs.callPackage ./linux-5.10.2 {};
}
