# iMac 18,2, NixOS 24.05 (2024)

## Audio
- [ ] broken until https://github.com/NixOS/nixpkgs/pull/322968 lands in master

## Bluetooth
- [ ] broken until https://github.com/NixOS/nixpkgs/pull/322964 lands in master

## Thunderbolt
- [x] ok

## SATA
- [x] ok

## NVME
- [x] ok, older NVME / Controller may need workaround for resume

## Suspend/Resumer
- [ ] Thunderbolt, WIFI, NVME may still need reboot (sometimes).

## Wifi
- [x] Working (2,4Ghz & 5Ghz supported), WEP3 broken -> brcm fw blob (2015) 

## Resources (Intel iMac/MacBook share similar custom hardware)
- https://github.com/Dunedan/mbp-2016-linux?tab=readme-ov-file
- https://gist.github.com/roadrunner2/1289542a748d9a104e7baec6a92f9cd7
