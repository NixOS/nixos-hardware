# Dell Vostro 5501

## Specifications

- **CPU:** 10th Generation Intel Core i3-1005G1 / i5-1035G1 / i7-1065G7 (Ice Lake)
- **iGPU:** Intel UHD Graphics / Intel Iris Plus Graphics
- **dGPU (Optional):** NVIDIA GeForce MX330 (2 GB GDDR5)


## USB-C ACPI Error Messages

If you encounter ACPI errors related to `ucsi_acpi` regarding USB Power Delivery sink roles, you can add the following in your system's `configuration.nix`:


```nix
boot.kernelParams = [ "ucsi_acpi.sink_has_roles=0" ];
```
