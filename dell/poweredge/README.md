[Dell Poweredge R7515](https://www.dell.com/en-us/work/shop/productdetailstxn/poweredge-r7515#techspecs_section)

## Install bios update via UEFI

UEFI updates cannot be updated via the iDrac since it only supports BIOS
firmware files.  If you use systemd boot you can however download the EFI
firmware file and put it in `/boot/EFI/Dell/bios-update.efi`.

Also write the following efi boot entry file as
`/boot/loader/entries/z-efi-update.conf`:

```
title EFI update
efi /efi/Dell/bios-update.efi
```
