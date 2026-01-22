## Dell Precision 5560

- Intel i7-11800H
- 00:02.0 VGA compatible controller [0300]: Intel Corporation TigerLake-H GT1 [UHD Graphics] [8086:9a60] (rev 01)
- 01:00.0 3D controller [0302]: NVIDIA Corporation TU117GLM [T1200 Laptop GPU] [10de:1fbc] (rev a1)

If you want to use the new Intel Xe driver, add this to your config:
```nix
boot.extraModprobeConfig = ''
  options xe force_probe=9a60
  options i915 force_probe=!9a60
'';
```

And you should decide what you want to do with the NVIDIA GPU, either sync or offload.

Fwupd works, you can update the BIOS and DBX.
