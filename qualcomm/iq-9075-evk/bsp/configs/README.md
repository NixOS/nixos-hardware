# IQ-9075 kernel config

Same model as other `nixos-hardware` BSP kernels (`buildLinux` + board
`defconfig`), mirroring meta-qcom `linux-qcom_6.18.bb`:

| File | Role |
|------|------|
| `iq9075_evk_defconfig` | Board defconfig (`savedefconfig` of the QLI fragment merge) |
| `bsp-additions.cfg` | Provenance only — vendored from meta-qcom `51f767dd` (`linux-qcom-6.18/configs/`); already baked into `iq9075_evk_defconfig` |

Fragment merge used to generate `iq9075_evk_defconfig`:

```text
arch/arm64/configs/defconfig
+ arch/arm64/configs/prune.config
+ arch/arm64/configs/qcom.config
+ bsp-additions.cfg
+ UKI/NixOS overrides (no EFI_ZBOOT, no BTF, LOCALVERSION=-iq9075)
→ make olddefconfig && make savedefconfig
```

Regenerate after bumping the kernel rev or meta-qcom fragments.
