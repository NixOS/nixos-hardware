# Qualcomm QRB2210 / QCM2290

This directory contains NixOS hardware support for Qualcomm QRB2210/QCM2290
boards, starting with **Arduino UNO Q** (board codename **Imola**).

The goal of the `nixos-hardware` portion is to provide the reusable hardware
profile and BSP package definitions (kernel, firmware, U-Boot, boot image
components). Higher-level image-building, provisioning, and board-specific
first-boot services can live in a consumer flake.

