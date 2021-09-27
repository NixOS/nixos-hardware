{ lib, ... }:
{
  # Since 20.03, you must explicitly specify to use dhcp on an interface
  networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  # Helps with 4GiB of RAM
  zramSwap.enable = lib.mkDefault true;
}
