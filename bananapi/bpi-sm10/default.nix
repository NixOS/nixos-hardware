{
  lib,
  ...
}:

{
  # The BPI-SM10 (K3-CoM260) shares the same SoC, firmware and boot flow as the
  # K3 Pico-ITX. Only the device tree differs.
  imports = [ ../../spacemit/k3-pico-itx ];

  hardware.deviceTree.name = lib.mkForce "spacemit/k3_com260_ifx.dtb";
}
