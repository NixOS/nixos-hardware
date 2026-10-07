# ASUS ROG Flow Z13 GZ301Z (2022)

12th-gen Intel (Alder Lake) + NVIDIA Ampere (RTX 3050 Ti class). Sibling of
[`gz301vu`](../gz301vu) (2023, Raptor Lake + Ada). Same 13.4" 2-in-1 chassis
family; different SoC / GPU generation.

This profile enables `asusd` (platform: fans, charge limit, keyboard),
`supergfxd` (GPU mode switching, default not pinned), IIO sensors, NVIDIA
PRIME offload, and `i915.enable_psr=0`.

Thunderbolt 4 is on the board. The kernel controller comes from
`nixos-generate-config` (`thunderbolt` in initrd). `services.hardware.bolt`
is left off (userspace authorization for docks); enable it on the host if
you use a TB dock.

Not included:

- Elan `04f3:0c6e` fingerprint — not in stock libfprint; needs an overlay
- NVIDIA `open` / package channel
- Forced `supergfxd` mux mode (choose Hybrid vs `AsusMuxDgpu` per install)
