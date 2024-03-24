{ ... }:

{
  imports = [ ./hybrid ];

  specialisation.ddg.configuration = {
    # This specialisation is for the case where "DDG" (Dual-Direct GFX, A hardware feature that can enable in bios) is enabled, since the amd igpu is blocked at hardware level and the built-in display is directly connected to the dgpu, we no longer need the amdgpu and prime configuration.
    system.nixos.tags = [ "Dual-Direct-GFX-Mode" ];
    imports = [ ./nvidia ];
  };
}
