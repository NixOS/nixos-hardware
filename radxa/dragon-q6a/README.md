# Radxa Dragon Q6A

This SBC still needs a vendor kernel until 6.19 released, otherwise some important hardware like NVME won't work.

## edl-ng

[edl-ng](https://github.com/strongtz/edl-ng) is a modern, user-friendly tool for interacting with Qualcomm devices in Emergency Download (EDL) mode. It can be used to flash the SPI firmware or UFS image for Radxa Dragon Q6A.

The upstream repo supports nix flake to run easily by `github:strongtz/edl-ng#edl-ng` .
