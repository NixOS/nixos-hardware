# Valve Steam Deck (LCD, Jupiter)

Original Steam Deck (2022 LCD, Van Gogh APU). Not the OLED (Galileo) model.

This profile enables AMD CPU/GPU commons (including `amdgpu` in initrd and
32-bit graphics), `amd-pstate`, IIO sensors, portrait `fbcon`, and the
Jupiter display-core flicker workaround (`amdgpu.dc=1`,
`amdgpu.dcdebugmask=0x10`).

This is not [Jovian-NixOS](https://github.com/Jovian-Experiments/Jovian-NixOS).
No Steam session, Gamescope, or firmware-update stack is configured here.
